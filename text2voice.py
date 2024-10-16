import requests
import io
from pydub import AudioSegment
import simpleaudio as sa

def get_google_translate_audio(text, language_code, speed=1.0):
    url = f"https://translate.google.com/translate_tts?ie=UTF-8&q={text}&tl={language_code}&client=tw-ob&ttsspeed={speed}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }
    response = requests.get(url, headers=headers)
    
    if response.status_code == 200:
        return response.content
    else:
        print(f"Failed to get the audio file. Status code: {response.status_code}")
        return None

def play_audio(audio_data):
    if audio_data:
        audio_buffer = io.BytesIO(audio_data)
        audio_segment = AudioSegment.from_file(audio_buffer, format="mp3")
        play_obj = sa.play_buffer(audio_segment.raw_data, num_channels=audio_segment.channels, bytes_per_sample=audio_segment.sample_width, sample_rate=audio_segment.frame_rate)
        play_obj.wait_done()
    else:
        print("No audio data to play.")

# Esempio di utilizzo
text_to_translate = "Guarda come sono bello quando parlo!"
target_language_code = "it"  # Codice della lingua
speech_speed = 1.0  # Velocità di lettura (puoi sperimentare valori diversi)
audio_data = get_google_translate_audio(text_to_translate, target_language_code, speech_speed)
play_audio(audio_data)
exit()
