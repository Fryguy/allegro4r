#include "allegro4r.h"

/*
 * call-seq:
 *   load_midi(filename) -> a_midi
 *
 * Loads a MIDI file (handles both format 0 and format 1). Example:
 *   music = load_midi("backmus.mid")
 *   abort_on_error("Couldn't load background music!") if music.nil?
 *
 * Return value: Returns a reference to a MIDI structure, or nil on error.
 * Remember to free this MIDI file later to avoid memory leaks.
 */
VALUE a4r_API_load_midi(VALUE self, VALUE filename)
{
  MIDI *m = load_midi(StringValuePtr(filename));
  if (m == NULL)
    return Qnil;

  VALUE obj = Data_Wrap_Struct(cAPI_MIDI, 0, 0, m);
  return obj;
}

/*
 * call-seq:
 *   destroy_midi(midi) -> nil
 *
 * Destroys a MIDI structure when you are done with it. It is safe to call this
 * even when the MIDI file might be playing, because it checks and will kill it
 * off if it is active. Use this to avoid memory leaks in your program.
 */
VALUE a4r_API_destroy_midi(VALUE self, VALUE midi)
{
  MIDI *m;
  Data_Get_Struct(midi, MIDI, m);
  destroy_midi(m);
  return Qnil;
}

/*
 * call-seq:
 *   play_midi(midi, loop) -> int
 *
 * Starts playing the specified MIDI file, first stopping whatever music was
 * previously playing. If the loop flag is set to true, the data will be
 * repeated until replaced with something else, otherwise it will stop at the
 * end of the file. Passing a nil will stop whatever music is currently playing.
 *
 * Return value: Returns non-zero if an error occurs (this may happen if a
 * patch-caching wavetable driver is unable to load the required samples, or at
 * least it might in the future when somebody writes some patch-caching
 * wavetable drivers :-)
 */
VALUE a4r_API_play_midi(VALUE self, VALUE midi, VALUE loop)
{
  MIDI *m;
  if (midi == Qnil)
    m = NULL;
  else
    Data_Get_Struct(midi, MIDI, m);

  return INT2FIX(play_midi(m, RTEST(loop)));
}

/*
 * call-seq:
 *   midi_pause -> nil
 *
 * Pauses the MIDI player.
 */
VALUE a4r_API_midi_pause(VALUE self)
{
  midi_pause();
  return Qnil;
}

/*
 * call-seq:
 *   midi_resume -> nil
 *
 * Resumes playback of a paused MIDI file.
 */
VALUE a4r_API_midi_resume(VALUE self)
{
  midi_resume();
  return Qnil;
}

/*
 * call-seq:
 *   get_midi_length(midi) -> int
 *
 * This function will simulate playing the given MIDI, from start to end, to
 * determine how long it takes to play. After calling this function, midi_pos
 * will contain the negative number of beats, and midi_time the length of the
 * midi, in seconds.
 *
 * Note that any currently playing midi is stopped when you call this function.
 * Usually you would call it before play_midi, to get the length of the midi to
 * be played, like in this example:
 *   length = get_midi_length(my_midi)
 *   play_midi(my_midi)
 *   loop do
 *     pos = midi_time
 *     textprintf_ex(screen, font, 0, 0, c, -1, "%d:%02d / %d:%02d\n" %
 *       [pos / 60, pos % 60, length / 60, length % 60])
 *     rest(100)
 *     break unless pos <= length
 *   end
 *
 * Return value: Returns the value of midi_time, the length of the midi.
 */
VALUE a4r_API_get_midi_length(VALUE self, VALUE midi)
{
  MIDI *m;
  Data_Get_Struct(midi, MIDI, m);
  return INT2FIX(get_midi_length(m));
}

/*
 * call-seq:
 *   midi_pos -> int
 *
 * Stores the current position (beat number) in the MIDI file, or contains a
 * negative number if no music is currently playing. Useful for synchronising
 * animations with the music, and for checking whether a MIDI file has finished
 * playing.
 */
VALUE a4r_API_midi_pos(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  return LONG2FIX(midi_pos);
}

/*
 * call-seq:
 *   midi_time -> int
 *
 * Contains the position in seconds in the currently playing midi. This is
 * useful if you want to display the current song position in seconds, not as
 * beat number.
 */
VALUE a4r_API_midi_time(VALUE self)
{
  // TODO: Convert to data struct or cached or hooked variable?
  return LONG2FIX(midi_time);
}
