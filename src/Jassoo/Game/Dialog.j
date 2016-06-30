public struct Dialog {
	private static trigger trig= null;
	private dialog h;

	static method create ()->thistype {
		thistype this= thistype.allocate();
		this.h= DialogCreate();
		Utils.PutInteger(this.HandleId, this);
		return this;
	}
	method destroy () {
		Utils.FlushInteger(this.HandleId);
		DialogDestroy(this.h);
		this.h= null;
		this.deallocate();
	}

	method operator Handle ()->dialog { return this.h; }
	method operator HandleId ()->integer { return GetHandleId(this.h); }

	method Clear () { DialogClear(this.h); }
	method SetText (string text) { DialogSetMessage(this.h, text); }
	method Display (GamePlayer plr, boolean flag) { DialogDisplay(Player(plr), this.h, flag); }
	method AddButton (string buttonText, integer hotkey, Action action) {
		button btn= DialogAddButton(this.h, buttonText, hotkey);
		integer id= GetHandleId(btn);
		if (action!= 0) {
			Utils.PutInteger(id, action);
			TriggerRegisterDialogButtonEvent(thistype.trig, btn);
		}
		btn= null;
	}
	private static method onInit () {
		thistype.trig = CreateTrigger();
		TriggerAddCondition(thistype.trig, function ()->boolean {
			Action(Utils.Get(GetClickedButton())).evaluate(Utils.Get(GetClickedDialog()));
			return false;
		});
	}
}
