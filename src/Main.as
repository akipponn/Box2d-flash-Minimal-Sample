package {

	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class Main extends Sprite
	{
		public var m_world:b2World;
		public var m_velocityIterations:int = 10;
		public var m_positionIterations:int = 10;

		public var scale:Number = 20.0;	// the unit of the box2d world is "meter"
		public var m_timeStep:Number = 1.0/30.0;
		
		public function Main(){
			
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
									
			var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			var doSleep:Boolean = true;
	
			m_world = new b2World(gravity,doSleep);
			debug_draw();
			
			var body:b2Body;
			var bodyDef:b2BodyDef;			
			var boxShape:b2PolygonShape;	
			var fixtureDef:b2FixtureDef = new b2FixtureDef();		

			// ground
			addBox(0,300,300,10, b2Body.b2_staticBody);

			// boxes
			addBox(60,0,30,30, b2Body.b2_dynamicBody);
			addBox(55,50,30,30, b2Body.b2_dynamicBody);
			addBox(50,100,30,30, b2Body.b2_dynamicBody);
		}
		
		public function Update(e:Event):void
		{
			m_world.Step(m_timeStep, m_velocityIterations, m_positionIterations);
			m_world.ClearForces();
			m_world.DrawDebugData();
		}		
		
		public function addBox( x:int, y:int, _width:int, _height:int, type:uint):void
		{
			var body:b2Body;
			var bodyDef:b2BodyDef;			
			var boxShape:b2PolygonShape;	
			var fixtureDef:b2FixtureDef = new b2FixtureDef();		

			bodyDef = new b2BodyDef();
			bodyDef.position.Set( ( x + _width / 2) / scale, ( y + _height / 2) /scale);

			boxShape = new b2PolygonShape();
			boxShape.SetAsBox( (_width / 2) / scale, (_height / 2) / scale);

			fixtureDef.shape = boxShape;
			fixtureDef.density = 1.0;
			fixtureDef.friction = 0.5;
			fixtureDef.restitution = 0.2;

/* ユーザデータに持たせれば OK
			var sp:Sprite = new Sprite;
			sp.graphics.beginFill( 0xBBB00B, 0.6);
			sp.graphics.drawRect(0, 0, _width, _height);
			bodyDef.userData = sp;
			bodyDef.userData.width = _width; 
			bodyDef.userData.height = _height; 
*/			
			body = m_world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			body.SetType(type);	// !! body type を明示的に指定する
		}
		
		public function debug_draw():void 
		{	
			var dbgSprite:Sprite = new Sprite();
			addChild(dbgSprite);

			var dbgDraw:b2DebugDraw = new b2DebugDraw();			
			dbgDraw.SetSprite(dbgSprite);
			dbgDraw.SetDrawScale(scale);
			dbgDraw.SetFillAlpha(0.5);
			dbgDraw.SetLineThickness(1);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit);

			m_world.SetDebugDraw(dbgDraw);
		}
	}
}
