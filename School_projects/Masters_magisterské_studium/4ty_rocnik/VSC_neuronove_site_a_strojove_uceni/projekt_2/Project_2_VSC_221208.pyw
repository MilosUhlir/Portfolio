
import flet as ft
import keras
import numpy as np
import pandas as pd
from sklearn.preprocessing import LabelEncoder


class Buttons(ft.UserControl):  # Object incorporating all input control buttons of the app

    def __init__(self, outputs):
        super().__init__()
        self.outputs = outputs

    def train_data_file_set(self, e: ft.FilePickerResultEvent):
        # Load selected training data file's path into variable for later use
        self.Training_Data_File_Path = (
            ", ".join(map(lambda f: f.path, e.files)) if e.files else None
        )
        
        # Display selected file's name
        self.Selected_train_file_name = ", ".join(map(lambda f: f.name, e.files)) if e.files else "Canceled!"
        self.load_training_data_button.text = "Loaded Training File: " f"{self.Selected_train_file_name}"
        self.load_training_data_button.icon = None
        
        self.update()
        return (self.Training_Data_File_Path)


    def test_data_file_set(self, e: ft.FilePickerResultEvent):
        # Load selected testing data file's path into variable for later use
        self.Testing_Data_File_Path = (
            ", ".join(map(lambda f: f.path, e.files)) if e.files else "Canceled!"
        )
        
        # Display selected file's name
        self.Selected_test_file_name = ", ".join(map(lambda f: f.name, e.files)) if e.files else "Canceled!"
        self.load_testing_data_button.text = "Loaded Testing File: " f"{self.Selected_test_file_name}"
        self.load_testing_data_button.icon = None
        
        self.update()
        return (self.Testing_Data_File_Path)
    
    
    def train_net(self, e):
        
        self.Info_Text.value = "Training Started"
        self.Info_Text.bgcolor = ft.colors.BLUE
        self.update()
        
        self.train_data = self.Training_Data_File_Path
        
        if self.Layers_TF.value == '':
            self.layers = 1 # set default amount of layers
        else:
            self.layers = int(self.Layers_TF.value) # set desired amount of layers
        
        if self.Neurons_TF.value == '':
            self.neurons = 16 # set default amount of neurons per layer
        else:
            self.neurons = int(self.Neurons_TF.value) # set desired amount of neurons per layer
        
        if self.Epochs_TF.value == '':
            self.epochs = 10 # set default amount of epochs
        else:
            self.epochs = int(self.Epochs_TF.value) # set desired amount of epochs
        
        self.net, self.train_labels_str, self.train_labels = Network().Train_network(self.train_data, self.epochs, self.layers, self.neurons)
        
        # self.DEBUG.value = self.net
        
        self.Info_Text.value = "Training Finished"
        self.Info_Text.bgcolor = ft.colors.GREEN
        
        self.update()
        return
    
    
    def test_net(self, e):
        
        self.Info_Text.value = "Testing Started"
        self.Info_Text.bgcolor = ft.colors.BLUE
        self.update()
        
        self.test_data = self.Testing_Data_File_Path
        
        # self.net = self.net
        
        self.data_labels_str, self.data_labels, self.Test_out = Network().Test_network(self.net ,self.test_data)
        
        self.Info_Text.value = "Testing Finished"
        self.Info_Text.bgcolor = ft.colors.GREEN
        
        
        self.outputs.calculate_charts(self.train_labels_str, self.train_labels ,self.data_labels_str, self.data_labels, self.Test_out)
        
        self.update()
        return
    
    
    def build(self):
        
        # Text definitions
        self.Selected_train_file_TF = ft.Text()
        
        self.Selected_test_file_TF = ft.Text()
        
        self.Info_Text = ft.Text(
            weight=200
        )
        
        self.DEBUG = ft.Text()
        
        
        # Dialogs for loading data files
        self.load_training_data_dialog = ft.FilePicker(on_result = self.train_data_file_set)
        
        self.load_testing_data_dialog = ft.FilePicker(on_result = self.test_data_file_set)
        
        
        # Defining Buttons
        self.load_training_data_button = ft.ElevatedButton(
                "Pick Training Data File",
                width=350,
                icon=ft.icons.UPLOAD_FILE,
                on_click= lambda _: self.load_training_data_dialog.pick_files(
                    allow_multiple=True
                )
            )
        
        self.load_testing_data_button = ft.ElevatedButton(
                "Pick Testing Data File",
                width=350,
                icon=ft.icons.UPLOAD_FILE,
                on_click= lambda _: self.load_testing_data_dialog.pick_files(
                    allow_multiple=True
                )
            )
        
        self.Train_network_button = ft.ElevatedButton(
            "Train Network",
            width=350,
            icon=ft.icons.AUTO_GRAPH_ROUNDED,
            on_click= self.train_net
        )
        
        self.Test_network_button = ft.ElevatedButton(
            "Test Network",
            width=350,
            icon=ft.icons.AUTO_GRAPH_ROUNDED,
            on_click= self.test_net
        )
        
        # Defining Textfields
        self.Epochs_TF = ft.TextField(
            label="Set number of epochs (default is 10)",
            width=350,
            input_filter=ft.InputFilter(allow=True, regex_string=r"[0-9]", replacement_string="")
        )
        
        self.Layers_TF = ft.TextField(
            label="Set number of layers (default is 1)",
            width=350,
            input_filter=ft.InputFilter(allow=True, regex_string=r"[0-9]", replacement_string="")
        )
        
        self.Neurons_TF = ft.TextField(
            label="Set number of neurons (default is 16)",
            width=350,
            input_filter=ft.InputFilter(allow=True, regex_string=r"[0-9]", replacement_string="")
        )
        
        
        return ft.Column([
                ft.Row([self.load_training_data_button,self.Selected_train_file_TF]),
                ft.Row([self.load_testing_data_button,self.Selected_test_file_TF]),
                self.Layers_TF,
                self.Neurons_TF,
                self.Epochs_TF,
                self.Train_network_button,
                self.Test_network_button,
                self.Info_Text,
                
                self.DEBUG,
                
                self.load_training_data_dialog,
                self.load_testing_data_dialog
            ])




class Outputs(ft.UserControl):  # Object incorporating all output control buttons and vizualization of the app
    
    def calculate_charts(self, Train_labels_str, Train_labels, Test_labels_str, Test_labels, Test_output):
        
        self.train_labels_str = Train_labels_str
        self.train_labels = Train_labels
        
        self.test_labels_str = Test_labels_str
        
        self.test_labels = []
        
        if Test_labels is not None:
            for i in range(len(Test_labels)):
                self.test_labels.append(Test_labels[i])
            
            self.Logical_1 = self.train_labels_str[0]
            self.Logical_0 = None
            
            for i in range(1, len(self.train_labels_str)):
                if self.train_labels_str[i] == self.Logical_1:
                    pass
                elif self.train_labels_str[i] != self.Logical_1:
                    self.Logical_0 = self.train_labels_str[i]
                
                if self.Logical_0 != None and self.Logical_1 != None:
                    break
            
            print("Logical_0: ", self.Logical_0)
            print("Logical_1: ", self.Logical_1)
        
        else:
            pass
        
        self.output_raw = Test_output
        self.output = []
        
        for i in range(len(self.output_raw)):
            self.output.append(self.output_raw[i][0])
        
        self.out_1 = 0 # P (positive)
        self.out_2 = 0 # N (negative)
        
        for i in range(len(self.output)):
            if round(self.output[i]) == 1:
                self.out_1 += 1
            elif round(self.output[i]) == 0:
                self.out_2 += 1
        
        print(self.out_1)
        print(self.out_2)
        
        self.sections = [
            ft.PieChartSection(
                value= self.out_1/len(self.output),
                title=self.Logical_1,
                title_position=0.5,
                color=ft.colors.GREEN,
                radius=100
            ),
            ft.PieChartSection(
                value= self.out_2/len(self.output),
                title=self.Logical_0,
                title_position=0.5,
                color=ft.colors.RED,
                radius=100
            ),
            ft.PieChartSection(
                value= (len(self.output) - (self.out_1 + self.out_2))/len(self.output),
                title="NO DATA",
                title_position=0.5,
                color=ft.colors.GREY,
                radius=100
            )
        ]
        
        self.Chart_1.sections = self.sections
        self.update()
        
        self.TP = 0 # locical 1 (True Positive)
        self.TN = 0 # logical 0 (True Negative)
        self.FP = 0 # (False Positive)
        self.FN = 0 # (False Negative)
        
        if self.test_labels != None:
            for i in range(len(self.test_labels)):
                if round(self.output[i]) == self.test_labels[i]:
                    if round(self.output[i]) == 1:
                        self.TP += 1
                    else:
                        self.TN += 1
                else:
                    if round(self.output[i]) == 1:
                        self.FP += 1
                    else:
                        self.FN += 1
        
        
        self.eval_chart.sections = [
            ft.PieChartSection(
                value= self.TP/len(self.output),
                title="TP",
                title_position=1.3,
                color=ft.colors.GREEN,
                radius=100
            ),
            ft.PieChartSection(
                value= self.TN/len(self.output),
                title="TN",
                title_position=1.3,
                color=ft.colors.RED,
                radius=100
            ),
            ft.PieChartSection(
                value= self.FP/len(self.output),
                title="FP",
                title_position=1.3,
                color=ft.colors.BLUE,
                radius=100
            ),
            ft.PieChartSection(
                value= self.FN/len(self.output),
                title="FN",
                title_position=1.3,
                color=ft.colors.YELLOW,
                radius=100
            ),
            ft.PieChartSection(
                value= (len(self.output) - (self.out_1 + self.out_2))/len(self.output),
                title="NO DATA",
                title_position=1.3,
                color=ft.colors.GREY
            )
        ]
        self.update()
        
        
        self.ACC = (self.TP + self.TN)/(self.out_1 + self.out_2)
        
        
        print("Aditional Chart data: \n",
            "True Positive: ", self.TP, "\n",
            "True Negative: ", self.TN, "\n",
            "False Positive: ", self.FP, "\n",
            "False Negative: ", self.FN, "\n"
        )
        
        print("Accuracy: " f"{self.ACC}")
        self.Bin_accuracy.value = "Accuracy: " f"{self.ACC}"
        if self.ACC == 0.0:
            self.Bin_accuracy.value = "Accuracy: NO DATA"
            self.eval_chart.sections = self.default_pie_sec
        
        self.update()
        return
    
    
    def build(self):
        
        self.default_pie_sec = [
                ft.PieChartSection(
                    100,
                    title="NO DATA",
                    color=ft.colors.GREY,
                    radius=50
                )
            ]
        
        self.Chart_Title = ft.Text(
            value="Outputs Chart",
            width=350,
            text_align=ft.alignment.center
        )
        
        self.Chart_1 = ft.PieChart(
            sections= self.default_pie_sec,
            sections_space=5,
            center_space_radius=0,
            start_degree_offset=-90,
            height=240
        )
        
        self.Aditional_Charts_Title = ft.Text(
            value="Additional Charts: Binary Accuracy",
            width=350,
            text_align=ft.alignment.center
        )
        
        self.eval_chart = ft.PieChart(
            sections=[
                ft.PieChartSection(
                    100,
                    title="NO DATA",
                    color=ft.colors.GREY,
                    radius=50
                )
            ],
            sections_space=5,
            center_space_radius=0,
            start_degree_offset=-90,
            height=240
        )
        
        self.Bin_accuracy = ft.Text(
            value="Accuracy: NO DATA"
        )
        
        
        
        return ft.Column([
            self.Chart_Title,
            self.Chart_1,
            self.Aditional_Charts_Title,
            self.eval_chart,
            self.Bin_accuracy
        ])



class Network:
    
    
    def Train_network(self ,Train_File_Path, Epochs, n_layers, neur_p_layer, Activation_func='tanh'):
        
        self.label_encoder = LabelEncoder()
        
        self.train_data_path = Train_File_Path
        self.train_data = pd.read_csv(self.train_data_path)
        self.train_data.head()
        self.train_features = self.train_data.copy()
        self.train_labels_str = self.train_features.pop('class')
        # transforms inputs from strings to integers
        self.train_labels = self.label_encoder.fit_transform(self.train_labels_str)
        self.train_features = np.array(self.train_features)
        
        self.normalize = keras.layers.Normalization()
        self.normalize.adapt(self.train_features)
        
        
        self.model = keras.Sequential([
            self.normalize
        ])
        
        for n in range(n_layers):
            self.model.add(keras.layers.Dense(neur_p_layer,activation=f'{Activation_func}'))
        
        self.model.add(keras.layers.Dense(1, activation='linear'))
        
        self.test = self.model.predict(self.train_features[:10])
        print(self.test)
        
        self.model.compile(loss = 'mse', optimizer = 'Adam')
        
        self.model.fit(self.train_features, self.train_labels, epochs=Epochs)
        
        self.test = self.model.predict(self.train_features[:10])
        print(self.test)
        
        return (self.model, self.train_labels_str, self.train_labels)
    
    
    
    def Test_network(self, model, test_data_path):
        
        self.model = model
        
        self.label_encoder = LabelEncoder()
        
        self.data_path = test_data_path
        self.data = pd.read_csv(self.data_path)
        
        self.data.head()
        self.data_features = self.data.copy()
        
        self.label = False
        
        for i in range(len(self.data_features.columns)):
            if self.data_features.columns[i] == "class":
                self.data_labels_str = self.data_features.pop('class')
                self.label = True
                break
            else:
                self.data_labels_str = None
                self.label = False
        
        if self.label:
            self.data_labels = self.label_encoder.fit_transform(self.data_labels_str)
        else:
            self.data_labels = None
        
        self.Test_out = self.model.predict(self.data_features)
        
        return (self.data_labels_str, self.data_labels, self.Test_out)




def main(page: ft.Page):
    
    ## app window parameters
    page.title = "VSC projekt 2 - klasifikátor"
    page.window_width = 830
    page.window_height = 720
    page.window_resizable = True
    page.window_maximizable = True
    page.padding = 20
    
    
    outputs = Outputs()
    buttons = Buttons(outputs)
    
    ## Adding custom objects to window
    
    c2 = ft.Container(
        content= outputs,
        # content=ft.Text("Test"),
        padding= 10,
        bgcolor=ft.colors.PURPLE,
        height= 640,
        width=350+20,
        margin=0,
        alignment=ft.alignment.center
    )
    
    c1 = ft.Container(
        content = buttons,
        padding = 10,
        bgcolor=ft.colors.PURPLE,
        height = 640,
        width=350+20,
        margin=0
    )
    
    divider = ft.VerticalDivider(
        color=ft.colors.WHITE
    )
    
    # page.add(Outputs())
    
    page.add(ft.Row([c1, divider, c2]))
    
    page.update()



ft.app(target=main)