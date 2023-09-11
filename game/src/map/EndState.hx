package map;

class EndState extends State {
	override function update(s:Float) {
		super.update(s);

		Main.context.fillStyle = "#fff";

		Main.context.font = "80px serif";
		textCenter("Earnings Report", Main.canvas.height * 0.2);

		Main.context.font = "50px serif";
		textCenter('Purse: ${Inventory.pence}', Main.canvas.height * 0.4);

		var store = Inventory.getStoreValue();
		textCenter('Unsold Goods: ${store}', Main.canvas.height * 0.4 + 60);

		textCenter('Total: ${Inventory.pence + store}', Main.canvas.height * 0.4 + 120);
	}
}
