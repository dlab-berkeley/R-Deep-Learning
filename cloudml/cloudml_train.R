library(keras)
library(cloudml)

# Define hyperparameters for future optimization.
# See https://tensorflow.rstudio.com/tools/cloudml/articles/tuning.html#preparing-your-script
# And https://tensorflow.rstudio.com/tools/training_flags.html
my_flags = tfruns::flags(
  # Data directories
  flag_string("base_data_dir", "data-raw/Open_I_abd_vs_CXRs/"),

  # Neural architecture
  flag_integer("dense_units1", 128),
  flag_numeric("dropout1", 0.7),
  
  # Optimizer
  flag_numeric("learning_rate", 0.00001)
)

dirs = list()

# Don't include a "/" at the end of these, because list.files() will add later.
dirs$train = cloudml::gs_data_dir_local(paste0(my_flags$base_data_dir, "TRAIN"))
dirs$val = cloudml::gs_data_dir_local(paste0(my_flags$base_data_dir, "VAL"))

length((train_files = list.files(dirs$train, recursive = TRUE, full.names = TRUE)))

# Dimensions of our images.
img_width = img_height = 299L
batch_size = 5L

train_datagen = keras::image_data_generator(rescale = 1/255)

val_datagen = keras::image_data_generator(rescale = 1/255)

train_gen =
  train_datagen$flow_from_directory(dirs$train,
                                    target_size = c(img_width, img_height),
                                    batch_size = batch_size,
                                    class_mode = "binary")

val_gen =
  val_datagen$flow_from_directory(dirs$val,
                                  target_size = c(img_width, img_height),
                                  batch_size = batch_size,
                                  class_mode = "binary")

# This will download the inception weights the first time it is run (~84 MB)
base_model = keras::application_inception_v3(include_top = FALSE,
                                             input_shape = c(img_width, img_height, 3L))
# Outputs an 8x8x2048 tensor.
base_model$output_shape


# Add custom layer to inception.
model_top = base_model$output %>%
  layer_global_average_pooling_2d() %>%
  layer_dense(units = my_flags$dense_units1, activation = "relu") %>%
  layer_dropout(my_flags$dropout1) %>%
  layer_dense(units = 1, activation = "sigmoid")

# this is the model we will train
model = keras_model(inputs = base_model$input, outputs = model_top)

# first: train only the top layers (which were randomly initialized)
# i.e. freeze all convolutional InceptionV3 layers
# This is not working - appears to be a bug in RStudio Keras.
freeze_weights(base_model)

# Manually freeze the original inception layers, just train the last 3 layers.
freeze_weights(model, 1, length(model$layers) - 3)

model %>%
  compile(optimizer =
            optimizer_adam(#lr = 0.00001,
              lr = my_flags$learning_rate,
              beta_1 = 0.9,
              beta_2 = 0.999, epsilon = 1e-08,
              decay = 0.0),
  loss = loss_binary_crossentropy,
  metrics = "accuracy")

(num_train_samples = length(train_files))
num_validation_samples = 10L
epochs = 20L

## Fit model
cat("Beginning model training.\n")

# Train the model on the new data for a few epochs
history = model %>%
  fit_generator(train_gen,
                steps_per_epoch = as.integer(num_train_samples / batch_size),
                epochs = epochs,
                validation_data = val_gen,
                validation_steps = as.integer(num_validation_samples / batch_size))

# Review fitting history.
plot(history)
