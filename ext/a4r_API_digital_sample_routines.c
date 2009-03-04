#include "allegro4r.h"

/*
 * call-seq:
 *   load_sample(filename) -> a_sample
 *
 * Loads a sample from a file, supporting both mono and stereo WAV and mono VOC
 * files, in 8 or 16-bit formats, as well as formats handled by functions
 * registered using register_sample_file_type. Example:
 *   sample = load_sample(user_input)
 *   abort_on_error("Couldn't load sample!") if sample.nil?
 *
 * Return value: Returns a reference to the SAMPLE or nil on error. Remember to
 * free this sample later to avoid memory leaks.
 */
VALUE a4r_API_load_sample(VALUE self, VALUE filename)
{
  SAMPLE *s = load_sample(StringValuePtr(filename));
  if (s == NULL)
    return Qnil;

  VALUE obj = Data_Wrap_Struct(cAPI_SAMPLE, 0, 0, s);
  return obj;
}

/*
 * call-seq:
 *   destroy_sample(spl) -> nil
 *
 * Destroys a sample structure when you are done with it. It is safe to call
 * this even when the sample might be playing, because it checks and will kill
 * it off if it is active. Use this to avoid memory leaks in your program.
 */
VALUE a4r_API_destroy_sample(VALUE self, VALUE spl)
{
  SAMPLE *s;
  Data_Get_Struct(spl, SAMPLE, s);
  destroy_sample(s);
  return Qnil;
}

/*
 * call-seq:
 *   play_sample(spl, vol, pan, freq, loop) -> int
 *
 * Triggers a sample at the specified volume, pan position, and frequency. The
 * parameters 'vol' and 'pan' range from 0 (min/left) to 255 (max/right).
 * Frequency is relative rather than absolute: 1000 represents the frequency
 * that the sample was recorded at, 2000 is twice this, etc. If 'loop' is true,
 * the sample will repeat until you call stop_sample, and can be manipulated
 * while it is playing by calling adjust_sample. Example:
 *   # Scream from the left speaker, twice the freq.
 *   sound = play_sample(scream, 255, 0, 2000, false)
 *
 * Return value: Returns the voice number that was allocated for the sample or
 * negative if no voices were available.
 */
VALUE a4r_API_play_sample(VALUE self, VALUE spl, VALUE vol, VALUE pan, VALUE freq, VALUE loop)
{
  SAMPLE *s;
  Data_Get_Struct(spl, SAMPLE, s);
  return INT2FIX(play_sample(s, FIX2INT(vol), FIX2INT(pan), FIX2INT(freq), RTEST(loop)));
}

/*
 * call-seq:
 *   adjust_sample(spl, vol, pan, freq, loop) -> nil
 *
 * Alters the parameters of a sample while it is playing (useful for
 * manipulating looped sounds). You can alter the volume, pan, and frequency,
 * and can also clear the loop flag, which will stop the sample when it next
 * reaches the end of its loop. The values of the parameters are just like those
 * of play_sample. If there are several copies of the same sample playing, this
 * will adjust the first one it comes across. If the sample is not playing it
 * has no effect.
 */
VALUE a4r_API_adjust_sample(VALUE self, VALUE spl, VALUE vol, VALUE pan, VALUE freq, VALUE loop)
{
  SAMPLE *s;
  Data_Get_Struct(spl, SAMPLE, s);
  adjust_sample(s, FIX2INT(vol), FIX2INT(pan), FIX2INT(freq), RTEST(loop));
  return Qnil;
}
