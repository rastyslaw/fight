/**
 * Author: rastyslaw
 * Date: 17.07.2014
 * Time: 17:23
 */
package src.mvcs.view.skills {
	import flash.errors.IllegalOperationError;

	//Abstract class
	public class AbstractCreator {

		//Abstract method   
		public function creating(id: uint):IIcon {
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
			return null;
		}

	}
}