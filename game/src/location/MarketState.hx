package location;

import Types.Location;
import map.Map;
import ui.Button;
import ui.Number;

class MarketState extends State {
	private var l:Location;

	private var xPos:Array<Float> = [];
	private var lines:Array<Line> = [];

	private var confirm = new Button("Confirm", 60);
	private var reset = new Button("Reset", 60);
	private var back = new Button("Back", 60);

	public function new(l:Location) {
		super();
		this.l = l;

		for (p in [0, .1, .22, .42, .6, .73, .9]) {
			xPos.push(Main.width * p);
		}

		for (i in 0...Map.resources.length) {
			var price = Math.ceil(Map.resourceBasePrices[i] * l.demand[i]);
			var demandPercent = Math.round((l.demand[i] - 1) * 100);
			var demDir = demandPercent > 0 ? "▲" : "▼";
			var dem = demandPercent != 0 ? '($demDir$demandPercent%)' : "";

			lines.push({
				product: Map.resources[i],
				inventory: Inventory.store[i],
				sell: new Number(0, 0, Inventory.store[i]),
				price: price,
				priceStr: '$price$dem',
				market: l.qty[i],
				buy: new Number(0, 0, l.qty[i]),
				total: 0
			});
		}

		confirm.onClick = onConfirm;
		reset.onClick = () -> Main.setState(new MarketState(l));
		back.onClick = () -> Main.setState(new LocationState(l));
	}

	override function update(s:Float) {
		super.update(s);

		Main.context.font = "80px serif";
		Main.context.fillStyle = "#fff";
		textCenter(l.name + " Market", 80);

		var yAcc = 160;
		Main.context.font = "60px serif";
		var h = ["Item", "Have", "Sell", "Price", "Market", "Buy", "Total"];
		for (i in 0...h.length) {
			Main.context.fillText(h[i], xPos[i], yAcc);
		}
		yAcc += 40;

		Main.context.strokeStyle = "#fff";
		Main.context.beginPath();
		Main.context.moveTo(0, yAcc);
		Main.context.lineTo(Main.width, yAcc);
		Main.context.stroke();
		yAcc += 50;

		var txtOff = 60 * 0.9;
		var total = 0.0;
		for (l in lines) {
			// Product Icon
			Main.context.fillText(l.product, xPos[0], yAcc + txtOff);

			// Inventory
			Main.context.fillText(Std.string(l.inventory), xPos[1], yAcc + txtOff);

			// Sell
			l.sell.x = xPos[2];
			l.sell.y = yAcc;
			l.sell.update(s);

			// Price
			Main.context.fillText(l.priceStr, xPos[3], yAcc + txtOff);

			// Market
			Main.context.fillText(Std.string(l.market), xPos[4], yAcc + txtOff);

			// Buy
			l.buy.x = xPos[5];
			l.buy.y = yAcc;
			l.buy.update(s);

			// Total
			l.total = (l.price * l.sell.val) - (l.price * l.buy.val);
			total += l.total;
			Main.context.fillText(Std.string(l.total), xPos[6], yAcc + txtOff);

			yAcc += 100;
		}

		Main.context.fillText('Purse: ${Inventory.pence}', 40, yAcc + txtOff);
		var ttl = 'Grand Total: ${total}';
		var w = Main.context.measureText(ttl).width;
		Main.context.fillText(ttl, Main.width - w, yAcc + txtOff);

		yAcc += 100;

		back.x = 40;
		back.y = yAcc;
		back.update(s);

		confirm.y = yAcc;
		confirm.x = Main.width - confirm.w - 40;

		confirm.enable(Inventory.pence + total >= 0);
		confirm.update(s);

		reset.y = yAcc;
		reset.x = confirm.x - reset.w - 40;
		reset.update(s);
	}

	private function onConfirm() {
		var total = 0.0;
		for (i in 0...lines.length) {
			var l = lines[i];

			total += l.total;
			this.l.qty[i] = l.market - l.buy.val + l.sell.val;
			Inventory.store[i] = l.inventory - l.sell.val + l.buy.val;
		}
		Inventory.pence += Math.round(total);

		Main.setState(new MarketState(l));
	}
}

typedef Line = {
	var product:String;
	var inventory:Int;
	var sell:Number;
	var price:Int;
	var priceStr:String;
	var market:Int;
	var buy:Number;
	var total:Float;
};
