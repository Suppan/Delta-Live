//=============================================
// sfPlayerSC
//=============================================

// choose "Evaluate File" form the menu,
// or press cmd-a (select all)  + cmd-return

// single-play?=nil
// t   -> "performance-mode": every sf can be played only once
// nil -> "rehearse-mode": every sf can be restarted

(
var b1,button_sf1,synth_sf1;
var b2,button_sf2,synth_sf2;
var b3,button_sf3,synth_sf3;
var b4,button_sf4,synth_sf4;
var button_dump;
var dBsf1,dBsf2,dBsf3,dBsf4;
var dBtext1,dBtext2,dBtext3,dBtext4;
var sfPath0,sfPath1,sfPath2,sfPath3,sfPath4;

    s = Server.local;
    //s.options.device = "Fireface 400 (F0C)";    //ServerOptions.devices;
    s.options.memSize = 2**18;   //-> 262144 kilobytes (default: 2**13 -> 8192)
    s.boot;
    s.latency = 0;

s.waitForBoot({
    //dB-levels:
    //C:
    dBsf1   =     0.0;
    dBsf2   =     0.0;
    dBsf3   =     0.0;
    dBsf4   =     0.0;

    //Soundfile paths:
    sfPath0  = "/Users/wsuppan/Dropbox/2021/Apps/Delta-Live-0.12/sounds/C/";
    sfPath1  = sfPath0 ++ "9-car-horn-old.wav";
    sfPath2  = sfPath0 ++ "10-sticks.wav";
    sfPath3  = sfPath0 ++ "11-camera-noise.wav";
    sfPath4  = sfPath0 ++ "12-alabama.aif";

    //Buffer
    b1  = Buffer.cueSoundFile(s,sfPath1  ,0 ,2);
    b2  = Buffer.cueSoundFile(s,sfPath2  ,0 ,2);
    b3  = Buffer.cueSoundFile(s,sfPath3  ,0 ,1);
    b4  = Buffer.cueSoundFile(s,sfPath4  ,0 ,1);

    //Win
    w = Window("sfPlayer", Rect(130,100,700,272)).front;
    w.view.background = Color.white;
    StaticText(w, Rect(30,242,700,40)).string_("Press space to start a SF (SC selected and cmd-m opens the levelmeter window...) - replay: reselect and press space twice!")
    .font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\left);
    StaticText(w, Rect(30,10,180,30)).string_("C").font_(Font("Arial", 24, true)).stringColor_(Color.black).align_(\center);


    //SynthDef
    SynthDef(\Play1chan,{|bufnum, gain=1 ,mul=1|
        Out.ar(0, VDiskIn.ar( 1, bufnum, rate: 1.0 ) * mul );
        }).send(s);

    SynthDef(\Play2chan,{|bufnum, gain=1 ,mul=1|
        Out.ar(0, VDiskIn.ar( 2, bufnum, rate: 1.0 ) * mul );
        }).send(s);

    //SF-1 button
    dBtext1 = StaticText(w, Rect(165,48,80,20)).string_(dBsf1.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf1 = Button(w, Rect(40,43,140,36))
    .font_(Font("Courir",12))
    .states_([["9-car-horn-old.wav", Color.black],["9-car-horn-old.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf1.value == 0, {
                       b1 = Buffer.cueSoundFile(s,sfPath1,0,2);
                       },{synth_sf1 = Synth.new(\Play2chan,[\bufnum,b1,\mul, dBsf1.dbamp]);button_sf2.focus(true);
                                         })});
    //SF-2 button
    dBtext2 = StaticText(w, Rect(165,98,80,20)).string_(dBsf2.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf2 = Button(w, Rect(40,93,140,36))
    .font_(Font("Courir",12))
    .states_([["10-sticks.wav", Color.black],["10-sticks.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf2.value == 0, {
                       b2 = Buffer.cueSoundFile(s,sfPath2,0,2);
                       },{synth_sf2 = Synth.new(\Play2chan,[\bufnum,b2,\mul, dBsf2.dbamp]);button_sf3.focus(true);
                                         })});
    //SF-3 button
    dBtext3 = StaticText(w, Rect(165,148,80,20)).string_(dBsf3.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf3 = Button(w, Rect(40,143,140,36))
    .font_(Font("Courir",12))
    .states_([["11-camera-noise.wav", Color.black],["11-camera-noise.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf3.value == 0, {
                       b3 = Buffer.cueSoundFile(s,sfPath3,0,1);
                       },{synth_sf3 = Synth.new(\Play1chan,[\bufnum,b3,\mul, dBsf3.dbamp]);button_sf4.focus(true);
                                         })});
    //SF-4 button
    dBtext4 = StaticText(w, Rect(165,198,80,20)).string_(dBsf4.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf4 = Button(w, Rect(40,193,140,36))
    .font_(Font("Courir",12))
    .states_([["12-alabama.aif", Color.black],["12-alabama.aif",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf4.value == 0, {
                       b4 = Buffer.cueSoundFile(s,sfPath4,0,1);
                       },{synth_sf4 = Synth.new(\Play1chan,[\bufnum,b4,\mul, dBsf4.dbamp]);button_sf4.focus(false);
                                         })});



    //Focus
    button_sf1.focus(true);

    //Set focus color
    button_sf1.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf2.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf3.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf4.focusColor  = Color.red(val: 1.0, alpha: 0.8);

    //Close
    w.onClose = {
    b1.free;b2.free;b3.free;b4.free;
    s.freeAll;
    s.quit;
                };
});
)
