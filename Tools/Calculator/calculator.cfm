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
<cfparam name="attributes.form" default="Calc">
<cfparam name="attributes.name" default="amountfield">
<cfparam name="attributes.copy" default="amountfield">
<cfparam name="attributes.onchange" default="">

<cfoutput>
<script>

// Module-level variables
    
    var Accum = 0;		// Previous number (operand) awaiting operation
    var FlagNewNum = false;   // Flag to indicate a new number (operand) is being entered
    var PendingOp = "";		  // Pending operation waiting for completion of second operand
	
	function cformat(amount) {
		var objRegExp = new RegExp('(-?\[0-9]+)([0-9]{3})');
		while(objRegExp.test(amount)) amount = amount.toString().replace(objRegExp,'$1,$2');
		document.getElementById("#Attributes.Copy#").value = amount
	}	

    function NumPressed (Num) {
	
		se = document.getElementById("#Attributes.Name#")
	    
	    if (FlagNewNum) {					
		    se.value = Num;
            FlagNewNum = false;
			
        } else {	
				
					
            if (se.value == "0")
                se.value = Num;
            else
                se.value += Num;
        }
		
		cformat(se.value)
    }

    function Operation (Op) {
        var Readout = document.getElementById("#Attributes.Name#").value;
        //alert( 'op' );
        if (FlagNewNum && PendingOp != "=");
            // User is hitting op keys repeatedly, so don't do anything
        else
        {
            //alert( PendingOp );
            FlagNewNum = true;
            if ( '+' == PendingOp )
                Accum += parseFloat(Readout);
            else if ( '-' == PendingOp )
                Accum -= parseFloat(Readout);
            else if ( '/' == PendingOp )
                Accum /= parseFloat(Readout);
            else if ( '*' == PendingOp )
                Accum *= parseFloat(Readout);
            else
                Accum = parseFloat(Readout);
			
			se = document.getElementById("#Attributes.Name#")		
            se.value = Accum;
			cformat(se.value)
            PendingOp = Op;
        }
    }

    function Decimal () {
        var curReadOut = document.getElementById("#Attributes.Name#").value;

        if (FlagNewNum) {
            curReadOut = "0.";
            FlagNewNum = false;
        } else {
            if (curReadOut.indexOf(".") == -1)
                curReadOut += ".";
        }
		se = document.getElementById("#Attributes.Name#")
        se.value = curReadOut;
		cformat(se.value)
    }

    function ClearEntry ()  {
        // Remove current number and reset state
        document.getElementById("#Attributes.Name#").value = "0";
        FlagNewNum = true;
    }

    function Clear () {
	
        // Clear accumulator and pending operation, and clear display
        Accum = 0;
        PendingOp = "";		
        ClearEntry();
    }

    function Neg () {
	    se = document.getElementById("#Attributes.Name#")
        se.value = parseFloat(se.value) * -1;
		cformat(se.value)
    }

    function Percent () {
		se = document.getElementById("#Attributes.Name#")
		se.value = (parseFloat(se.value) / 100) * parseFloat(Accum);
		cformat(se.value)
    }

//-->
</script>

<table border="0" style="border:1px dotted silver" cellspacing="0" cellpadding="0">

<tr><td height="2"></td></tr>
<TR>
	<TD COLSPAN="3" height="25" width="75" align="center" style="padding-left:4px;padding-right:2px;padding-top:1px">
	<INPUT NAME="#Attributes.Name#" 
				id="#Attributes.Name#"
				style="border:solid,21px;height:19;text-align:right;text-underline-position : below;" 
				onchange="#attributes.onchange#" 
				value="#attributes.value#" 
				class="regular2" 
				TYPE="Text" 
				SIZE="10">
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnClear" id="btnClear" onclick="Clear()" class="button10s" style="width:20" TYPE="Button" VALUE="C"></TD>
	<TD height="25" width="25" style="padding-right:3px" align="center"><INPUT tabindex="999" NAME="btnClearEntry" id="btnClearEntry" onclick="ClearEntry()" class="button10s" style="width:20" TYPE="Button" VALUE="CE" ></TD>
</TR>
<TR>
	<TD height="25" width="25" style="padding-left:5px" align="center"><INPUT tabindex="999" NAME="btnSeven" id="btnSeven" class="button10s" style="width:24" TYPE="Button" VALUE="7" OnClick="NumPressed(7)"></TD>
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnEight" id="btnEight" class="button10s" style="width:24" TYPE="Button" VALUE="8" OnClick="NumPressed(8)"></TD>
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnNine" id="btnNine" class="button10s" style="width:24" TYPE="Button" VALUE="9" OnClick="NumPressed(9)"></TD>
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnNeg" id="btnNeg" onclick="Neg()" class="button10s" style="width:24" TYPE="Button" VALUE="+/-" ></TD>
	<TD height="25" width="25" style="padding-right:3px" align="center"><INPUT tabindex="999" NAME="btnPercent" id="btnPercent" onclick="Percent()" class="button10s" style="width:24" TYPE="Button" VALUE="%" ></TD>
</TR>
 
<TR>
	<TD height="25" width="25" style="padding-left:5px" align="center"><INPUT tabindex="999" NAME="btnFour" id="btnFour" class="button10s" style="width:24" TYPE="Button" VALUE="4" OnClick="NumPressed(4)"></TD>
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnFive" id="btnFive" class="button10s" style="width:24" TYPE="Button" VALUE="5" OnClick="NumPressed(5)"></TD>
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnSix" id="btnSix" class="button10s" style="width:24" TYPE="Button" VALUE="6" OnClick="NumPressed(6)"></TD>
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnPlus" id="btnPlus" onclick="Operation('+')" class="button10s" style="width:24" TYPE="Button" VALUE="+"></TD>
	<TD height="25" width="25" style="padding-right:3px" align="center"><INPUT tabindex="999" NAME="btnMinus" id="btnMinus" onclick="Operation('-')" class="button10s" style="width:24" TYPE="Button" VALUE="-"></TD>
</TR>
<TR>
	<TD height="25" width="25" style="padding-left:5px" align="center"><INPUT tabindex="999" NAME="btnOne" id="btnOne" class="button10s" style="width:24" TYPE="Button" VALUE="1" OnClick="NumPressed(1)"></TD>
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnTwo" id="btnTwo" class="button10s" style="width:24" TYPE="Button" VALUE="2" OnClick="NumPressed(2)"></TD>
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnThree" id="btnThree" class="button10s" style="width:24" TYPE="Button" VALUE="3" OnClick="NumPressed(3)"></TD>
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnMultiply" id="btnMultiply" onclick="Operation('*')" class="button10s" style="width:24" TYPE="Button" VALUE="*" ></TD>
	<TD height="25" width="25" style="padding-right:3px" align="center"><INPUT tabindex="999" NAME="btnDivide" id="btnDivide" onclick="Operation('/')" class="button10s" style="width:24" TYPE="Button" VALUE="/" ></TD>
</TR>
<TR>
	<TD height="25" width="25" style="padding-left:5px" align="center"><INPUT tabindex="999" NAME="btnZero" id="btnZero" class="button10s" style="width:24" TYPE="Button" VALUE="0" OnClick="NumPressed(0)"></TD>
	<TD height="25" width="25" align="center"><INPUT tabindex="999" NAME="btnDecimal" id="btnDecimal" onclick="Decimal()" class="button10s" style="width:24" TYPE="Button" VALUE="." ></TD>
	<TD COLSPAN=2 bgcolor="white" width="50" align="center">
	
	<input type="button"
       name="close"
	   id="close"
       value="close"
       class="button10s"
	   style="width:48"       
       onClick="togglecalc()">
	
	</TD>
	<TD height="25" width="25" style="padding-right:3px" align="center"><INPUT tabindex="999" NAME="btnEquals" id="btnEquals" onclick="Operation('=')" class="button10s" style="width:20" TYPE="Button" VALUE="="></TD>
</TR>
<tr><td height="4"></td></tr>

</TABLE>

</cfoutput>
