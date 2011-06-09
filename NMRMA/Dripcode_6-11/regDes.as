﻿package{	import flash.display.Sprite;	public class regDes extends Sprite	{		private var desc:Array = new Array(20);				public function regDes():void		{			desc[0] = "The New England region flows out into the Atlantic Ocean through many different rivers, such as the Connecticut, the Merrimack, and the Penobscot."+"\n"+"\n"+  			"The region includes all of Maine, New Hampshire and Rhode Island and parts of Connecticut, Massachusetts, New York, and Vermont.";			desc[1] ="The Mid-Atlantic region drains into the Atlantic Ocean.  Major rivers in this region include the Hudson, the Delaware, and the Potomac."+"\n"+"\n"+			"The region covers all of Delaware, New Jersey and the District of Columbia, and parts of Connecticut, Maryland, Massachusetts, New York, Pennsylvania, Vermont, Virginia, and West Virginia.";			desc[2] ="The South Atlantic-Gulf region is split by the Eastern Continental Divide, so water either flows east to the Atlantic Ocean or southwest to the Gulf of Mexico.  The divide is formed by the Appalachian Mountains."+"\n"+"\n"+  			"The region includes all of Florida and South Carolina, and parts of Alabama, Georgia, Louisiana, Mississippi, North Carolina, Tennessee, and Virginia."+"\n"+"\n"+ 			"Examples of main rivers that reach the Atlantic Ocean are the Roanoke and Savannah.  On the Gulf side, examples include the Chattahoochee and Apalachicola." ;						desc[3] ="The Great Lakes region drains into one of the five Great Lakes through rivers like the Detroit, the Cuyahoga, and the Fox.  Since the Great Lakes are interconnected, water from this region eventually reaches the Atlantic Ocean through the St. Lawrence Seaway."+"\n"+"\n"+			"The region covers parts of Illinois, Indiana, Michigan, Minnesota, New York, Ohio, Pennsylvania, and Wisconsin.";			desc[4] ="The Ohio region is one of six regional watersheds that eventually join the Mississippi River and drain into the Gulf of Mexico. Together, these regions form the world’s third largest watershed and pass through 31 states."+"\n"+"\n"+ 			"The Ohio River is the dominant river in the Ohio region.  The region covers parts of Illinois, Indiana, Kentucky, Maryland, New York, North Carolina, Ohio, Pennsylvania, Tennessee, Virginia, and West Virginia.";			desc[5] ="The Tennessee region is one of six regional watersheds that eventually join the Mississippi River and drain into the Gulf of Mexico. Together, these regions form the world’s third largest watershed and pass through 31 states."+"\n"+"\n"+ 			"The Tennessee River is the main river in the Tennessee region.  The region includes parts of Alabama, Georgia, Kentucky, Mississippi, North Carolina, Tennessee, and Virginia.";						desc[6] ="The Upper Mississippi region is one of six regional watersheds that eventually join the Mississippi River and drain into the Gulf of Mexico.  Together, these regions form the world’s third largest watershed and pass through 31 states."+"\n"+"\n"+			"From its origins in northern Minnesota, the Mississippi River travels south throughout the Upper Mississippi region.  The region includes parts of Illinois, Indiana, Iowa, Michigan, Minnesota, Missouri, South Dakota, and Wisconsin.";						desc[7] ="The Lower Mississippi region is one of six regional watersheds that eventually join the Mississippi River and drain into the Gulf of Mexico. Together, these regions form the world’s third largest watershed and pass through 31 states."+"\n"+"\n"+			"At the southern tip of the Lower Mississippi region, the river passes through Louisiana and flows into the Gulf.  Other states included in the region are Arkansas, Kentucky, Mississippi, Missouri, and Tennessee.";						desc[8] ="The Souris-Red-Rainy region takes its name from the three main rivers that run through the area.  These rivers flow north into Canada and drain into Lake Winnipeg and Hudson Bay."+"\n"+"\n"+			"This region covers parts of Minnesota, North Dakota, and South Dakota.";						desc[9] ="The Missouri region is one of six regional watersheds that eventually join the Mississippi River and drain into the Gulf of Mexico. Together, these regions form the world’s third largest watershed and pass through 31 states."+"\n"+"\n"+			"The Missouri River is the main river in the Missouri region, which includes all of Nebraska and parts of Colorado, Iowa, Kansas, Minnesota, Missouri, Montana, North Dakota, South Dakota, and Wyoming.";						desc[10] ="The Arkansas-White-Red region is one of six regional watersheds that eventually join the Mississippi River and drain into the Gulf of Mexico. Together, these regions form the world’s third largest watershed and pass through 31 states."+"\n"+"\n"+			"The region gets its name from three of the major rivers in the area: the Arkansas, the White, and the Red.  It covers all of Oklahoma and parts of Arkansas, Colorado, Kansas, Louisiana, Missouri, New Mexico, and Texas.";			desc[11] ="The Texas-Gulf watershed empties into the Gulf of Mexico through such rivers as the Brazos, San Antonio, and the Trinity."+"\n"+"\n"+			"The region includes most of Texas and parts of Louisiana and New Mexico.";						desc[12] ="The Rio Grande region flows into the Gulf of Mexico."+"\n"+"\n"+			"From its start in the mountains of Colorado, the Rio Grande runs south through New Mexico and southeast through Texas, where it forms part of the US-Mexico border.  The river is the fourth longest in the US." ;			desc[13] ="The Upper Colorado region is where the Colorado River begins its journey through the southwest.  The river ends in the neighboring Lower Colorado watershed region."+"\n"+"\n"+			"The Colorado River plays an important role in the region.  It provides the primary source of drinking water and generates hydroelectric power.  The region covers parts of Arizona, Colorado, New Mexico, Utah, and Wyoming.";						desc[14] ="In the Lower Colorado region, the Colorado River flows south toward Mexico and the Gulf of California.  In recent years, the river has dried up before reaching the Gulf, due in part to the large amount of water diverted by dams."+"\n"+"\n"+ 			"The river is a vital resource for cities like Phoenix and Las Vegas, which rely on the Colorado for their water supply.  The region includes most of Arizona and small areas of California, Nevada, New Mexico, and Utah.";			desc[15] ="The Great Basin region does not drain to an ocean.  The water is trapped by mountains, and much of it evaporates in the desert conditions."+"\n"+"\n"+ 			"There are, however, some rivers in this region, such as the Bear River and the Truckee River.  The Great Basin is also home to two large lakes: the Great Salt Lake and Lake Tahoe."+"\n"+"\n"+ 			"The region covers most of Nevada and parts of California, Idaho, Oregon, Utah, and Wyoming.";						desc[16] ="The Pacific Northwest region carries water flowing from sources such as the Snake River and the Columbia River into the Pacific Ocean."+"\n"+"\n"+			"The region includes all of Washington state, most of Idaho and Oregon, and parts of California, Montana, Nevada, Utah, and Wyoming.";						desc[17] ="The California region drains into the Pacific Ocean through such rivers as the Sacramento and the San Joaquin."+"\n"+"\n"+			"The region covers almost all of California, as well as small parts of Nevada and Oregon.";						desc[18] ="The Alaska region empties into three bodies of water: the Arctic Ocean, the Bering Sea, and the Gulf of Alaska."+"\n"+"\n"+			"Major rivers in the state include the Yukon and Kuskokwin.";						desc[19] ="The Hawaii region includes the entire chain of Hawaiian Islands and drains into the Pacific Ocean.  A few of the larger rivers on the islands are the Wailuku, the Waimea, and the Kaukonahua.";		}				public function getDesc(i:Number):String		{			var resultDesc:String = desc[i];			return resultDesc;		}					}}