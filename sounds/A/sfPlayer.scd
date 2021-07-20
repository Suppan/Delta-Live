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
var b5,button_sf5,synth_sf5;
var b6,button_sf6,synth_sf6;
var b7,button_sf7,synth_sf7;
var b8,button_sf8,synth_sf8;
var b9,button_sf9,synth_sf9;
var button_dump;
var dBsf1,dBsf2,dBsf3,dBsf4,dBsf5,dBsf6,dBsf7,dBsf8,dBsf9;
var dBtext1,dBtext2,dBtext3,dBtext4,dBtext5,dBtext6,dBtext7,dBtext8,dBtext9;
var sfPath0,sfPath1,sfPath2,sfPath3,sfPath4,sfPath5,sfPath6,sfPath7,sfPath8,sfPath9;

    s = Server.local;
    //s.options.device = "Fireface 400 (F0C)";    //ServerOptions.devices;
    s.options.memSize = 2**18;   //-> 262144 kilobytes (default: 2**13 -> 8192)
    s.boot;
    s.latency = 0;

s.waitForBoot({
    //dB-levels:
    //A:
    dBsf1   =     0.0;
    dBsf2   =     0.0;
    dBsf3   =     0.0;
    dBsf4   =     0.0;
    dBsf5   =     0.0;
    dBsf6   =     0.0;
    dBsf7   =     0.0;
    dBsf8   =     0.0;
    dBsf9   =     0.0;

    //Soundfile paths:
    sfPath0  = "/Users/wsuppan/Dropbox/2021/Apps/Delta-Live-0.12/sounds/A/";
    sfPath1  = sfPath0 ++ "0-sticks.wav";
    sfPath2  = sfPath0 ++ "1-water-splash.wav";
    sfPath3  = sfPath0 ++ "2-machine-noise1.wav";
    sfPath4  = sfPath0 ++ "3-machine-noise2.wav";
    sfPath5  = sfPath0 ++ "4-ugly-horn.wav";
    sfPath6  = sfPath0 ++ "5-crowd.wav";
    sfPath7  = sfPath0 ++ "6-kung-fu.wav";
    sfPath8  = sfPath0 ++ "7-car-stop.wav";
    sfPath9  = sfPath0 ++ "8-children.wav";

    //Buffer
    b1  = Buffer.cueSoundFile(s,sfPath1  ,0 ,2);
    b2  = Buffer.cueSoundFile(s,sfPath2  ,0 ,2);
    b3  = Buffer.cueSoundFile(s,sfPath3  ,0 ,2);
    b4  = Buffer.cueSoundFile(s,sfPath4  ,0 ,2);
    b5  = Buffer.cueSoundFile(s,sfPath5  ,0 ,2);
    b6  = Buffer.cueSoundFile(s,sfPath6  ,0 ,2);
    b7  = Buffer.cueSoundFile(s,sfPath7  ,0 ,2);
    b8  = Buffer.cueSoundFile(s,sfPath8  ,0 ,2);
    b9  = Buffer.cueSoundFile(s,sfPath9  ,0 ,2);

    //Win
    w = Window("sfPlayer", Rect(130,100,700,522)).front;
    w.view.background = Color.white;
    StaticText(w, Rect(30,492,700,40)).string_("Press space to start a SF (SC selected and cmd-m opens the levelmeter window...) - replay: reselect and press space twice!")
    .font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\left);
    StaticText(w, Rect(30,10,180,30)).string_("A").font_(Font("Arial", 24, true)).stringColor_(Color.black).align_(\center);


    //SynthDef
    SynthDef(\Play2chan,{|bufnum, gain=1 ,mul=1|
        Out.ar(0, VDiskIn.ar( 2, bufnum, rate: 1.0 ) * mul );
        }).send(s);

    //SF-1 button
    dBtext1 = StaticText(w, Rect(165,48,80,20)).string_(dBsf1.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf1 = Button(w, Rect(40,43,140,36))
    .font_(Font("Courir",12))
    .states_([["0-sticks.wav", Color.black],["0-sticks.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf1.value == 0, {
                       b1 = Buffer.cueSoundFile(s,sfPath1,0,2);
                       },{synth_sf1 = Synth.new(\Play2chan,[\bufnum,b1,\mul, dBsf1.dbamp]);button_sf2.focus(true);
                                         })});
    //SF-2 button
    dBtext2 = StaticText(w, Rect(165,98,80,20)).string_(dBsf2.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf2 = Button(w, Rect(40,93,140,36))
    .font_(Font("Courir",12))
    .states_([["1-water-splash.wav", Color.black],["1-water-splash.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf2.value == 0, {
                       b2 = Buffer.cueSoundFile(s,sfPath2,0,2);
                       },{synth_sf2 = Synth.new(\Play2chan,[\bufnum,b2,\mul, dBsf2.dbamp]);button_sf3.focus(true);
                                         })});
    //SF-3 button
    dBtext3 = StaticText(w, Rect(165,148,80,20)).string_(dBsf3.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf3 = Button(w, Rect(40,143,140,36))
    .font_(Font("Courir",12))
    .states_([["2-machine-noise1.wav", Color.black],["2-machine-noise1.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf3.value == 0, {
                       b3 = Buffer.cueSoundFile(s,sfPath3,0,2);
                       },{synth_sf3 = Synth.new(\Play2chan,[\bufnum,b3,\mul, dBsf3.dbamp]);button_sf4.focus(true);
                                         })});
    //SF-4 button
    dBtext4 = StaticText(w, Rect(165,198,80,20)).string_(dBsf4.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf4 = Button(w, Rect(40,193,140,36))
    .font_(Font("Courir",12))
    .states_([["3-machine-noise2.wav", Color.black],["3-machine-noise2.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf4.value == 0, {
                       b4 = Buffer.cueSoundFile(s,sfPath4,0,2);
                       },{synth_sf4 = Synth.new(\Play2chan,[\bufnum,b4,\mul, dBsf4.dbamp]);button_sf5.focus(true);
                                         })});
    //SF-5 button
    dBtext5 = StaticText(w, Rect(165,248,80,20)).string_(dBsf5.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf5 = Button(w, Rect(40,243,140,36))
    .font_(Font("Courir",12))
    .states_([["4-ugly-horn.wav", Color.black],["4-ugly-horn.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf5.value == 0, {
                       b5 = Buffer.cueSoundFile(s,sfPath5,0,2);
                       },{synth_sf5 = Synth.new(\Play2chan,[\bufnum,b5,\mul, dBsf5.dbamp]);button_sf6.focus(true);
                                         })});
    //SF-6 button
    dBtext6 = StaticText(w, Rect(165,298,80,20)).string_(dBsf6.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf6 = Button(w, Rect(40,293,140,36))
    .font_(Font("Courir",12))
    .states_([["5-crowd.wav", Color.black],["5-crowd.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf6.value == 0, {
                       b6 = Buffer.cueSoundFile(s,sfPath6,0,2);
                       },{synth_sf6 = Synth.new(\Play2chan,[\bufnum,b6,\mul, dBsf6.dbamp]);button_sf7.focus(true);
                                         })});
    //SF-7 button
    dBtext7 = StaticText(w, Rect(165,348,80,20)).string_(dBsf7.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf7 = Button(w, Rect(40,343,140,36))
    .font_(Font("Courir",12))
    .states_([["6-kung-fu.wav", Color.black],["6-kung-fu.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf7.value == 0, {
                       b7 = Buffer.cueSoundFile(s,sfPath7,0,2);
                       },{synth_sf7 = Synth.new(\Play2chan,[\bufnum,b7,\mul, dBsf7.dbamp]);button_sf8.focus(true);
                                         })});
    //SF-8 button
    dBtext8 = StaticText(w, Rect(165,398,80,20)).string_(dBsf8.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf8 = Button(w, Rect(40,393,140,36))
    .font_(Font("Courir",12))
    .states_([["7-car-stop.wav", Color.black],["7-car-stop.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf8.value == 0, {
                       b8 = Buffer.cueSoundFile(s,sfPath8,0,2);
                       },{synth_sf8 = Synth.new(\Play2chan,[\bufnum,b8,\mul, dBsf8.dbamp]);button_sf9.focus(true);
                                         })});
    //SF-9 button
    dBtext9 = StaticText(w, Rect(165,448,80,20)).string_(dBsf9.asString++" dB").font_(Font("Arial", 12)).stringColor_(Color.gray).align_(\center);
    button_sf9 = Button(w, Rect(40,443,140,36))
    .font_(Font("Courir",12))
    .states_([["8-children.wav", Color.black],["8-children.wav",Color.white, Color.gray]])
    .action_({ arg butt, mod;
                   if (button_sf9.value == 0, {
                       b9 = Buffer.cueSoundFile(s,sfPath9,0,2);
                       },{synth_sf9 = Synth.new(\Play2chan,[\bufnum,b9,\mul, dBsf9.dbamp]);button_sf9.focus(false);
                                         })});



    //Focus
    button_sf1.focus(true);

    //Set focus color
    button_sf1.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf2.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf3.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf4.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf5.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf6.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf7.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf8.focusColor  = Color.red(val: 1.0, alpha: 0.8);
    button_sf9.focusColor  = Color.red(val: 1.0, alpha: 0.8);

    //Close
    w.onClose = {
    b1.free;b2.free;b3.free;b4.free;b5.free;b6.free;b7.free;b8.free;b9.free;
    s.freeAll;
    s.quit;
                };
});
)
