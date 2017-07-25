function frame = time2frame(time,fps,offset)
frame = round((time+offset)*fps);
