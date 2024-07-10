

import keras
import numpy as np
import pandas as pd
from sklearn.preprocessing import LabelEncoder


def NN(Train_File_Path, Test_File_Path, n_layers, neur_p_layer, Activation_func):
    
    label_encoder = LabelEncoder()
    
    train_data_path = Train_File_Path
    train_data = pd.read_csv(train_data_path)
    train_data.head()
    train_features = train_data.copy()
    train_labels = train_features.pop('class')
    # transforms inputs from strings to integers
    train_labels = label_encoder.fit_transform(train_labels)
    train_features = np.array(train_features)


    test_data_path = Test_File_Path
    test_data = pd.read_csv(test_data_path)
    test_data.head()
    test_features = test_data.copy()
    if len(test_features.columns) == 8:
        test_labels = test_features.pop('class')
        test_labels = label_encoder.fit_transform(train_labels)
    else:
        pass


    # Creating the network
    normalize = keras.layers.Normalization()
    normalize.adapt(train_features)


    model = keras.Sequential([
        normalize
    ])

    for n in n_layers:
        model.add(keras.layers.Dense(neur_p_layer, activation=f'{Activation_func}'))

    model.add(keras.layers.Dense(1, activation='linear'))

    test = model.predict(train_features[:10])
    print(test)

    model.compile(loss = 'mse', optimizer = 'Adam')


    model.fit(train_features, train_labels, epochs=100)

    print("POTATO")

    model.evaluate(train_features, train_labels)

    model_test = model.predict(test_features)
    print(model_test)
    
    
    pass