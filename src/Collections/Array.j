public struct Array {
	//! runtextmacro Array_Common("", "thistype")
	
	method Sort (Comparer comparer) {
		this.quickSort(0, this.size - 1, comparer);
	}
	
	private method quickSort (integer low, integer high, Comparer comparer) {
		if (low >= high) {
			return;
		}
		integer first = low;
		integer last = high;
		integer key = this.table[first];
		while (first < last) {
			while (first < last && comparer.evaluate(this.table[last], key) >= 0 ) {
				last -= 1;
			}
			this.table[first] = this.table[last];

			while (first < last && comparer.evaluate(this.table[first], key) <= 0) {
				first += 1;
			}
			this.table[last] = this.table[first];
		}
		this.table[first] = key;
		this.quickSort(low, first - 1, comparer);
		this.quickSort(first + 1, high, comparer);
	}
}

public struct ArrayEnumerator extends IEnumerator {
	private Table table;
	private integer size;
	private integer position;
	
	method operator Current ()->integer {
		if (this.position < 0) {
			return 0;
		}
		return this.table[this.position];
	}
	
	static method create (Table table, integer size) {
		thistype this = thistype.allocate();
		this.table = table;
		this.size = size;
		this.position = -1;
		return this;
	}
	
	method MoveNext ()->boolean {
		this.position += 1;
		if (this.position < this.size) {
			return true;
		}
		this.destroy();
		return false;
	}
	
	method Reset () {
		this.position = -1;
	}
}
	
