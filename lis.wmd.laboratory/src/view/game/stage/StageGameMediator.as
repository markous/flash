package view.game.stage
{
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import messages.DataMsg;
	import messages.ViewMsg;
	import model.AssetFactoryProxy;
	import model.GameBoardProxy;
	import model.GameItemVO;
	import model.GameProxy;
	import model.SynthProxy;
	import org.mvcexpress.mvc.Mediator;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.extensions.ParticleSystem;
	import view.game.IGameItem;
	
	/**
	 * ...
	 * @author Marek Lis
	 */
	public class StageGameMediator extends Mediator
	{
		
		[Inject]
		public var view:StageGame;
		
		[Inject]
		public var gameProxy:GameProxy;
		
		[Inject]
		public var gameBoardProxy:GameBoardProxy;
		
		[Inject]
		public var assetFactoryProxy:AssetFactoryProxy;
		
		[Inject]
		public var synthProxy:SynthProxy;
		
		private var _stageGameView:StageGame;
		
		override public function onRegister():void
		{
			trace(this + " onRegister");
			view.init(gameProxy.screenWidth, gameProxy.screenHeight);
			view.start();
			view.addEventListener(StageGameEvent.TICK, onTickHandler);
			view.addEventListener(StageGameEvent.CLICK, onClickHandler);
			
			addHandler(DataMsg.ADD_ITEM, onAddItemHandler);
			addHandler(DataMsg.REMOVE_ITEM, onRemoveItemHandler);
			addHandler(DataMsg.BOUNCE_ITEM, onBounceItemHandler);
			
			sendMessage(ViewMsg.CLICK, {x: (gameProxy.screenWidth >> 1), y: (gameProxy.screenHeight >> 1)});
		}
		
		override public function onRemove():void
		{
			trace(this + " onRemove");
			
			removeHandler(DataMsg.ADD_ITEM, onAddItemHandler);
			removeHandler(DataMsg.REMOVE_ITEM, onRemoveItemHandler);
			removeHandler(DataMsg.BOUNCE_ITEM, onBounceItemHandler);
			
			view.removeEventListener(StageGameEvent.TICK, onTickHandler);
			view.removeEventListener(StageGameEvent.CLICK, onClickHandler);
			view.stop();
		}
		
		private function onClickHandler(e:Event):void
		{
			//trace(this + " onClickHandler " + e);
			if (gameProxy.enabled && gameProxy.active) {
				sendMessage(ViewMsg.CLICK, e.data);
			}
		}
		
		private function onTickHandler(e:Event):void
		{
			//trace(this + " onTickHandler " + e + " " + gameProxy.active);
			if (gameProxy.enabled && gameProxy.active) {
				sendMessage(ViewMsg.TICK, e.data);
			}
		}
		
		private function onAddItemHandler(item:StageGameItem):void
		{
			trace(this + " onAddItemHandler " + item.getVO().id);
			//item.setColor(synthProxy.getNoteColor(Math.random()));
			view.addChild(item);
			item.showMe();
		}
		
		private function onRemoveItemHandler(item:StageGameItem):void
		{
			trace(this + " onRemoveItemHandler " + item.getVO().id);
			item.hideMe(function():void { 
				view.removeChild(item);
			});
		}
		
		private function onBounceItemHandler(params:Object):void 
		{
			/*
			var particle:ParticleSystem = assetFactoryProxy.getParticle();
			particle.scaleX = particle.scaleY = params.item1.getVO().scale + params.item2.getVO().scale;
			particle.x = params.bouncePoint.x;
			particle.y = params.bouncePoint.y;
			Starling.current.juggler.add(particle);
			particle.start(0.1);
			view.addChild(particle);
			
			setTimeout(function():void {
				view.removeChild(particle);
				Starling.current.juggler.remove(particle);
			}, 1000);
			*/
			synthProxy.playNote(params.ratio1);
			synthProxy.playNote(params.ratio2);
			
		}
	
	}

}