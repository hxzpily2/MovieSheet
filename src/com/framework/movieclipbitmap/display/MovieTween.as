package com.framework.movieclipbitmap.display
{
import com.framework.movieclipbitmap.core.Juggler;

import flash.display.MovieClip;
import com.framework.movieclipbitmap.core.Animatable;

/**
 * 补间动画类
 * @author Rakutens
 */
public dynamic class MovieTween extends Animatable
{
    /**
     *
     * @param sourceMc
     * @param autoDraw 是否自动生成Bitmap，如果为false则将在设置scale参数后再生成
     * @param fps 未开放功能，可以无视
     *
     */
    public function MovieTween(sourceMc:MovieClip, autoDraw:Boolean = true, fps : int = 30)
    {
        super(sourceMc, autoDraw, fps);
    }
    
    override protected function proceedParsing():Boolean
    {
        for (var i:uint=1; i<=sourceMc.totalFrames; i++)
        {
            sourceMc.gotoAndStop(i);
            if (sourceMc.currentFrameLabel)
            {
                currentLabels[sourceMc.currentFrameLabel] = i;
            }
        }
        var libMc:MovieClipSub = globalMcLib[getCurrentMcName(0)];
        if (!libMc)
        {
            _currentMc = new MovieClipSub(objParser.renderToTextures(sourceMc, true), _fps);
            _currentMc.name = sourceMc.name+"|tween";
            _currentMc.isSwfMC = true;
            globalMcLib[getCurrentMcName(0)] = _currentMc;
        }
        else
        {
            _currentMc = libMc.clone();
        }
        return true;
    }
    
    override protected function gotoFrame(frame : Object):void
    {
        //不作任何处理，override是为了防止可能的意外
    }
    
    override public function gotoAndStop(frame : Object, scene:String=null) : void
    {
        if (frame is String)
        {
            frame = _currentLabels[frame];
        }
        _currentFrame = int(frame);
        _currentMc.gotoAndStop(_currentFrame)
    }
    
    override public function gotoAndPlay(frame : Object, scene:String=null) : void
    {
        if (frame is String)
        {
            frame = _currentLabels[frame];
        }
        _currentFrame = int(frame);
        _currentMc.gotoAndPlay(_currentFrame)
    }
    override protected function finishParsing():void
    {
        super.finishParsing();
        Juggler.getInstance().add(_currentMc);
        addChild(_currentMc);
        
        if (needAutoPlay)
        {
            this.play();
        }
    }
}
}