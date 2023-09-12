package map;

class EndState extends State {
	private var ranks = [
		{w: 0, r: "F"},
		{w: 1000, r: "E"},
		{w: 5000, r: "D"},
		{w: 10000, r: "C"},
		{w: 20000, r: "B"},
		{w: 30000, r: "A"},
		{w: 40000, r: "S"}
	];

	private var store:Int;
	private var rank:String;

	public function new() {
		super();
		store = Inventory.getStoreValue();
		var t = Inventory.pence + store;
		for (r in ranks) {
			if (r.w > t) {
				break;
			}
			rank = r.r;
		}
	}

	override function update(s:Float) {
		super.update(s);

		Main.context.fillStyle = "#fff";

		Main.context.font = "80px serif";
		textCenter("Earnings Report", Main.canvas.height * 0.2);

		Main.context.font = "50px serif";
		textCenter('Purse: ${Inventory.pence}', Main.canvas.height * 0.4);
		textCenter('Unsold Goods: ${store}', Main.canvas.height * 0.4 + 60);
		textCenter('Total: ${Inventory.pence + store}', Main.canvas.height * 0.4 + 120);

		textCenter('Rank: ${rank}', Main.canvas.height * 0.4 + 240);
	}
}
