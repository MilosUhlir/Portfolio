import flet as ft
# import numpy as np
# import keras as k

class Core_Class(ft.UserControl):
    
    def build(self):
        self.file_picker = ft.FilePicker()
        
        self.file = ft.ElevatedButton("Choose files...",
            on_click=lambda _: ft.FilePicker().pick_files(allow_multiple=True))
        
        self.Classify = ft.ElevatedButton(
            "Klasifikovat",
            color = ft.colors.WHITE,
            bgcolor=ft.colors.ORANGE,
            width=150,
            on_click=self.Classify
        )
        
        return ft.Column([
            self.Classify,
            self.file
        ])
    
    
    def __init__(self):
        self.Training_Data = None


def main(page: ft.Page):

    load_train_data_dialog = ft.FilePicker(on_result=train_data_file_set)
    
    def train_data_file_set(e: ft.FilePickerResultEvent):
        Core_Class.Training_Data = (
            ", ".join(map(lambda f: f.name, e.files)) if e.files else "Canceled!"
        )
    


    ## app window parameters
    page.title = "VSC projekt 2 - klasifikátor"
    page.window_width = 640
    page.window_height = 360
    page.window_resizable = False
    page.window_maximizable = False
    page.overlay.append(Core_Class().build().file_picker)


    ## Custom objects calling to window
    c1 = ft.Container(
        content = Core_Class(),
        padding = 5,
        height = page.window_height-20
    )
    
    page.add(ft.Row([c1], spacing = 20))
    
    page.update()



ft.app(target=main)