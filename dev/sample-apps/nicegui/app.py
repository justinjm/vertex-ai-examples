from nicegui import ui

ui.add_head_html('''
<style>
.main-area { padding: 20px; }
.sidebar { width: 300px; background-color: #f0f0f0; padding: 20px; }
.output-area { border: 1px solid #ccc; padding: 10px; height: 200px; width: 500px; overflow-y: auto; }
</style>
''')

with ui.column().classes('main-area'): # Left side for prompt input, submit button and output
    # Prompt input area
    prompt_input = ui.textarea().props('rows=10 placeholder="Enter your prompt here..."')

    # Submit button
    def submit_prompt():
        prompt_text = prompt_input.value  # Get the prompt text directly
        # ... (Add logic to send the prompt to the Vertex AI API and get the response)
        output_area.content = "Model response goes here... (replace with actual Vertex AI response)"

    ui.button('Submit', on_click=submit_prompt)  # No need to pass the event object
    # Output area
    output_area = ui.markdown().classes('output-area')  
    
with ui.column().classes('sidebar'):  # Right sidebar for user input controls
    ui.label('Google CloudVertex AI Studio')

    # Example user input controls
    ui.input('Model Name', value='text-bison@001')
    ui.input('Temperature', value='0.2')
    ui.input('Max Output Tokens', value='1024')
    



    

ui.run()
