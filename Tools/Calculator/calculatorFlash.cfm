<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfsavecontent variable="setlogic">
if(_global.mode == undefined)
{
	_global.mode = "started";
	display.text = 0;
	var display = display;
	display.restrict = "0-9.";
	_global.calculate = function(value)
	{
		if(_global.mode == "started")
		{
			display.text = ( value != ".") ? "":0;
			_global.mode = "input";
		}
		if(!isNaN(value) || value == ".")
		{
			if(_global.mode == "input") display.text += value;
			else if(_global.mode == "overwrite") display.text = ( value != ".") ? value:"0.";
			_global.mode = "input";
		}
		else
		{
			if(value == "c")
			{
				_global.mode = "overwrite";
				display.text = 0;
				return;
			}
			if(_global.previousOP != undefined && _global.mode != "overwrite") 
			{
				switch(_global.previousOP)
				{
					case "+": display.text = Number(_global.previousData) + Number(display.text);
							  break;
					case "-": display.text = Number(_global.previousData) - Number(display.text);
							  break;
					case "/": display.text = Number(_global.previousData) / Number(display.text);
							  break;
					case "x": display.text = Number(_global.previousData) * Number(display.text);
							  break;
				}
			}
			
			_global.previousOP = value;
			_global.previousData = display.text;
			_global.mode = "overwrite";
			//alert(_global.mode);
		}
	}
}
else if(_global.mode != "off")
{
	display.text = "";
	display.enabled = false;
	_global.previousOP = undefined;
	_global.previousData = undefined;
	_global.mode = "off";
}
else
{
	display.text = 0;
	_global.mode = "started";
}
</cfsavecontent>
<cfform name="myform" height="300" width="170" format="Flash" timeout="0" style="marginLeft:20; marginTop:20; themeColor:##F8C446;">
	<cfformgroup type="panel" style="marginLeft:10; headerColors:##F5E4BC, ##F8C446; headerHeight:32; panelBorderStyle:'roundCorners'; backgroundColor:##FFEA94" label="CF Calculator">
	 	<cfformgroup type="hbox" width="125" style="verticalGap:0; textAlign:'right'; backgroundColor:##FDD880; fontSize:16; marginLeft:-12;" id="displayHolder">
			<cfinput type="text" height="24" disabled="true" name="display" style="disabledColor:##555555;" />
		</cfformgroup>
		<cfformgroup type="horizontal" width="125" style="verticalGap:4; marginLeft:-12; marginBottom:-4;">
     			 <cfinput type="Button" name="onOff" width="58" value = "on/off" onclick="#setlogic#" style="cornerRadius:10; fillColors:##FFCA4D,##FFCA4D; borderThickness:1;">
     			 <cfinput type="Button" name="multi" width="22" value = "C" onclick="_global.calculate('c')" style="cornerRadius:10; borderThickness:1;">
	  			 <cfinput type="Button" name="div" width="22" value = "/" onclick="_global.calculate('/')" style="cornerRadius:10; borderThickness:1;">
			</cfformgroup>
		<cfformgroup type="hbox">
		 	<cfformgroup type="vbox" width="24"  style="verticalGap:4;">
     			 <cfinput type="Button" name="num7" width="22" value = "7" onclick="_global.calculate(7)" style="cornerRadius:11; borderThickness:1;">
     			 <cfinput type="Button" name="num4" width="22" value = "4" onclick="_global.calculate(4)" style="cornerRadius:11; borderThickness:1;">
	  			 <cfinput type="Button" name="num1" width="22" value = "1" onclick="_global.calculate(1)" style="cornerRadius:11; borderThickness:1;">
				 <cfinput type="Button" name="num0" width="22" value = "0" onclick="_global.calculate(0)" style="cornerRadius:11; borderThickness:1;">
			</cfformgroup>
			<cfformgroup type="vbox" width="24"  style="verticalGap:4;">
     			 <cfinput type="Button" name="num8" width="22" value = "8" onclick="_global.calculate(8)" style="cornerRadius:11; borderThickness:1;">
     			 <cfinput type="Button" name="num5" width="22" value = "5" onclick="_global.calculate(5)" style="cornerRadius:11; borderThickness:1;">
	  			 <cfinput type="Button" name="num2" width="22" value = "2" onclick="_global.calculate(2)" style="cornerRadius:11; borderThickness:1;">
				 <cfinput type="Button" name="dot" width="22" value = "." onclick="_global.calculate('.')" style="cornerRadius:11; borderThickness:1;">
			</cfformgroup>
			<cfformgroup type="vbox" width="24"  style="verticalGap:4;">
     			 <cfinput type="Button" name="num9" width="22" value = "9" onclick="_global.calculate(9)" style="cornerRadius:11; borderThickness:1;">
     			 <cfinput type="Button" name="num6" width="22" value = "6" onclick="_global.calculate(6)" style="cornerRadius:11; borderThickness:1;">
	  			 <cfinput type="Button" name="num3" width="22" value = "3" onclick="_global.calculate(3)" style="cornerRadius:11; borderThickness:1;">
				 <cfinput type="Button" name="clear" width="22" value = "=" onclick="_global.calculate('=')" style="cornerRadius:11; borderThickness:1;">
			</cfformgroup>
			<cfformgroup type="vbox" width="24"  style="verticalGap:4;">
     			 <cfinput type="Button" name="minus" width="22" value = "X" onclick="_global.calculate('x')" style="cornerRadius:11; borderThickness:1;">
     			 <cfinput type="Button" name="plus" width="22" value = "-" onclick="_global.calculate('-')" style="cornerRadius:11; borderThickness:1;">
	  			 <cfinput type="Button" name="equal" width="22" value = "+" onclick="_global.calculate('+')" style="cornerRadius:11; borderThickness:1;">
				 
			</cfformgroup>
			
		</cfformgroup>
	</cfformgroup>
</cfform>

<input type="button" name="save" id="save" value="save" onclick="alert(myform.display.value)">
</body>
</html>
