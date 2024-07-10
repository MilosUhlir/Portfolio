


import tensorflow as tf
import keras
import numpy as np
import pandas as pd
from sklearn.preprocessing import LabelEncoder

label_encoder = LabelEncoder()


train_data_path = "C:/Users/milda/OneDrive/Desktop/VŠ/NMS/2_sem_ing_2024/VSC_neuronky/projekt_2/train_copy.csv"

train_data = pd.read_csv(train_data_path)
train_data.head()

train_features = train_data.copy()
train_labels = train_features.pop('class')

# transforms inputs from strings to integers
print('train labels old:', train_labels)
train_labels = label_encoder.fit_transform(train_labels)
print('train labels new:', train_labels)
train_features = np.array(train_features)



test_data_path = "C:/Users/milda/OneDrive/Desktop/VŠ/NMS/2_sem_ing_2024/VSC_neuronky/projekt_2/test_copy.csv"
# test_data_path = "C:/Users/milda/OneDrive/Desktop/VŠ/NMS/2_sem_ing_2024/VSC_neuronky/projekt_2/unknown_copy.csv"

test_data = pd.read_csv(test_data_path)
test_data.head()

test_features = test_data.copy()

print(len(test_features.columns))
print(test_features.columns)
print('features: \n',test_features)
if len(test_features.columns) == 8:
    test_labels_str = test_features.pop('class')
    
    test_labels = label_encoder.fit_transform(test_labels_str)
    
    print('potato')
    print(test_labels_str)
    print(test_labels)
    
    print('potato')
else:
    print("no labels")




normalize = keras.layers.Normalization()
normalize.adapt(train_features)


model = keras.Sequential([
    normalize,
    keras.layers.Dense(64, activation='tanh'),
    keras.layers.Dense(64, activation='tanh'),
    keras.layers.Dense(64, activation='tanh'),
    keras.layers.Dense(1, activation='linear')
])

test = model.predict(train_features[:10])
print(test)

model.compile(loss = 'mse', optimizer = 'Adam')


model.fit(train_features, train_labels, epochs=10)

print("POTATO")

model.evaluate(train_features, train_labels)

model_test = model.predict(test_features[:10])
print("model_test: ",model_test)

model_test_df = pd.DataFrame(model_test)

done = model_test_df.to_csv('Model_test.csv')

print(done)