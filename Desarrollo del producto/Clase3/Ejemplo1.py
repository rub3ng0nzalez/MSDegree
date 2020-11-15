# -*- coding: utf-8 -*-
"""
Created on Sat Oct 17 16:54:13 2020

@author: ruben
"""

# En consola escribir siempre conda activate streamlit
#Para que active streamlit y pueda hacer el ejercicio de la clase

#Para ejecutar este archivo escribir en consola: streamlit run <archivo.py>


import streamlit as st
import numpy as np
import pandas as pd
import time

st.title('This is my first Application in Streamlit')

x=4

st.write(x, 'square is', x*x)

x, 'square is', x*x

f"""
# Esto es un titulo
Esto es un texto,
{x} square is {x*x}


"""


st.write("Here's our first attempt at using data to create a table:")
st.write(pd.DataFrame({
    'first column': [1, 2, 3, 4],
    'second column': [10, 20, 30, 40]
}))


df = pd.DataFrame({
  'first column': [1, 2, 3, 4],
  'second column': [10, 20, 30, 40]
})

df

#Graficas
chart_data = pd.DataFrame(
     np.random.randn(20, 3),
     columns=['a', 'b', 'c'])

st.line_chart(chart_data)


#Mapa
map_data = pd.DataFrame(
    np.random.randn(1000, 2) / [50, 50] + [37.76, -122.4],
    columns=['lat', 'lon'])

st.map(map_data)

if st.checkbox('Show dataframe'):
    map_data
    
    
"""
## Now we work with Widgets!
"""

'This is an slider example'


x = st.slider('x')
st.write(x, 'square', x*x)

# Dropbox
option = st.selectbox(
    'Pick a number',
     df['first column'])

'You selected: ', option


option_side = st.sidebar.selectbox(
    'Please select one',
     ["hello", "world", "!"])

'You selected:', option_side
    
# Progress Bar
'Starting a long computation...'

# Initializing the variables
latest_iteration = st.empty()
bar = st.progress(0)

for i in range(100):
  # Update the progress bar with each iteration.
  latest_iteration.text(f'Iteration {i+1}')
  bar.progress(i + 1)
  time.sleep(0.01)

'...and now we\'re done!'


# SideBar
add_selectbox = st.sidebar.selectbox(
    'How would you like to be contacted?',
    ('Email', 'Home phone', 'Mobile phone')
)

add_slider = st.sidebar.slider(
    'Select a range of values',
    0.0, 100.0, (25.0, 75.0)
)






























    