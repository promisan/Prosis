<!--
    Copyright © 2025 Promisan B.V.

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
<div style="width:187px; height:239px" id="calculator">
	<div class="widrelwrapper">
	<cfoutput>
	<div class="widgetclose" onclick="widgetclose('calculator','#SystemFunctionId#')">X</div>
	</cfoutput>
	<form name="calc">
		<input type="text" name="input" size="16">
		<div id="cont">
			<input type="button" name="one"   value="  1  " onclick="calc.input.value += '1'">
			<input type="button" name="two"   value="  2  " onclick="calc.input.value += '2'">
			<input type="button" name="three" value="  3  " onclick="calc.input.value += '3'">
			<input class="last function" type="button" name="plus"  value="  +  " onclick="calc.input.value += ' + '">

			<input type="button" name="four"  value="  4  " onclick="calc.input.value += '4'">
			<input type="button" name="five"  value="  5  " onclick="calc.input.value += '5'">
			<input type="button" name="six"   value="  6  " onclick="calc.input.value += '6'">
			<input class="last function" type="button" name="minus" value="  -  " onclick="calc.input.value += ' - '">

			<input type="button" name="seven" value="  7  " onclick="calc.input.value += '7'">
			<input type="button" name="eight" value="  8  " onclick="calc.input.value += '8'">
			<input type="button" name="nine"  value="  9  " onclick="calc.input.value += '9'">
			<input class="last function" type="button" name="times" value="  x  " onclick="calc.input.value += ' * '">

			<input class="clearButton" type="button" name="clear" value="  c  " onclick="calc.input.value = ''">
			<input type="button" name="zero"  value="  0  " onclick="calc.input.value += '0'">
			<input class="function" type="button" name="doit"  value="  =  " onclick="calc.input.value = eval(calc.input.value)">
			<input class="last function" type="button" name="div"   value="  /  " onclick="calc.input.value += ' / '">
		
		</div>
		
	</form>
	
	</div>
</div>