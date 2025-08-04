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
<cfsetting enablecfoutputonly="No" showdebugoutput="No">

<!-- --------------------------------------- -->
<!-- CF_BarcodeGenarator (REGISTERED)        -->
<!-- --------------------------------------- -->
<!-- BarcodeType=1 Interleaved 2 of 5        -->
<!-- BarcodeType=2 Code 2 of 5               -->
<!-- BarcodeType=3 Code 39                   -->
<!-- BarcodeType=4 USPS PostNet              -->
<!-- BarcodeType=5 Codabar                   -->
<!-- BarcodeType=6 UPC-E                     -->
<!-- BarcodeType=7 UPC-A                     -->
<!-- BarcodeType=8 Code128 (Characterset B)  -->
<!-- BarcodeType=9 EAN13                     -->
<!-- BarcodeType=11 Code128 (Characterset C) -->
<!-- --------------------------------------- -->

<cfsetting enablecfoutputonly="Yes">
<CFPARAM name="ShowNagger"             default="0">
<CFPARAM name="BarcodesProtected"      default="NO">
<cfparam name="Attributes.BarCodeType" default="1">
<cfparam name="Attributes.BarCode"     default="1234567890">
<cfparam name="Attributes.Height"      default="70">
<cfparam name="Attributes.ImageDir"    default="#SESSION.root#/images/barcode/">
<CFPARAM name="Attributes.Runner"      default="0">
<CFPARAM name="Attributes.ThinWidth"   default="2">
<CFPARAM name="Attributes.ThickWidth"  default="4">
<cfparam name="attributes.iWidth"      default="1" >

<CFSET TwoOfFive=ArrayNew(2)>
<cfset TwoOfFive[01]=ListToArray("0,0,1,1,0")> <!--- Character 0 --->
<cfset TwoOfFive[02]=ListToArray("1,0,0,0,1")> <!--- Character 1 --->
<cfset TwoOfFive[03]=ListToArray("0,1,0,0,1")> <!--- Character 2 --->
<cfset TwoOfFive[04]=ListToArray("1,1,0,0,0")> <!--- Character 3 --->
<cfset TwoOfFive[05]=ListToArray("0,0,1,0,1")> <!--- Character 4 --->
<cfset TwoOfFive[06]=ListToArray("1,0,1,0,0")> <!--- Character 5 --->
<cfset TwoOfFive[07]=ListToArray("0,1,1,0,0")> <!--- Character 6 --->
<cfset TwoOfFive[08]=ListToArray("0,0,0,1,1")> <!--- Character 7 --->
<cfset TwoOfFive[09]=ListToArray("1,0,0,1,0")> <!--- Character 8 --->
<cfset TwoOfFive[10]=ListToArray("0,1,0,1,0")> <!--- Character 9 --->
<CFSET TwoOfFiveStart="0000">
<CFSET TwoOfFiveStop="101">

<!--- 2 of 5 --->
<CFIF Attributes.BarCodeType eq 1>

  <!--- 2 of 5 Interleaved --->
  <!--- Start character - thin, thin, thin, thin --->
  <CFOUTPUT><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"></CFOUTPUT>
  <!--- Main BarCode generator --->
  <CFLOOP index="c" from="1" to="#len(Attributes.BarCode)#" step="2">
    <CFSET first=mid(Attributes.BarCode,c,1)+1>
    <CFSET second=mid(Attributes.BarCode,c+1,1)+1>
    <CFLOOP index="t" from="1" to="5">
      <!--- Send a  bar, decide thin / thick --->
      <CFIF TwoOfFive[first][t] eq 0>
        <!--- Thin bar --->
  		  <CFOUTPUT><IMG width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"></CFOUTPUT>
      <CFELSE>
  	    <!--- Thick Bar --->
  		  <CFOUTPUT><IMG width="#Attributes.ThickWidth#" SRC="#Attributes.ImageDir#thickbar.gif" height="#Attributes.height#"></CFOUTPUT>
  	  </CFIF>
      <!--- Send a space, decide thin / thick --->
      <CFIF TwoOfFive[second][t] eq 0>
        <!--- Thin space --->
  		  <CFOUTPUT><IMG width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"></CFOUTPUT>
    	<CFELSE>
  	    <!--- Thick Space --->
  		  <CFOUTPUT><IMG width="#Attributes.ThickWidth#" SRC="#Attributes.ImageDir#thickspace.gif" height="#Attributes.height#"></CFOUTPUT>
  	  </CFIF>
    </CFLOOP>
  </CFLOOP>
  <!--- Stop character, thick, thin, thin --->
  <CFOUTPUT><img width="#Attributes.ThickWidth#" SRC="#Attributes.ImageDir#thickbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"></CFOUTPUT>
</CFIF>

<!--- 2 of 5 Interleaved --->
<CFIF Attributes.BarCodeType eq 2>
  <!--- Start character --->
  <CFOUTPUT><img width="#Attributes.ThickWidth#" SRC="#Attributes.ImageDir#thickbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"><img width="#Attributes.ThickWidth#" SRC="#Attributes.ImageDir#thickbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"></CFOUTPUT>
  <CFLOOP index="c" from="1" to="#len(Attributes.BarCode)#">
    <CFSET number=mid(Attributes.BarCode,c,1)+1>
    <CFLOOP index="t" from="1" to="5">
      <CFIF TwoOfFive[number][t] eq 0>
  		  <CFOUTPUT><IMG width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"></CFOUTPUT>
      <CFELSE>
  		  <CFOUTPUT><IMG width="#Attributes.ThickWidth#" SRC="#Attributes.ImageDir#thickbar.gif" height="#Attributes.height#"></CFOUTPUT>
  		</CFIF>
      <CFOUTPUT><IMG width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
    </CFLOOP>
  </CFLOOP>
  <!--- Stop character, thick, thin, thin --->
  <CFOUTPUT><img width="#Attributes.ThickWidth#" SRC="#Attributes.ImageDir#thickbar.gif" height="#Attributes.Height#"><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#Attributes.ThickWidth#" SRC="#Attributes.ImageDir#thickbar.gif" height="#Attributes.Height#"></CFOUTPUT>
</CFIF>

<!--- Code 39 --->
<CFIF Attributes.BarCodeType eq 3>
	<!--- this Code 39 by nature only accepts Uppercase letters --->
	<cfset attributes.BarCode = ucase(attributes.BarCode)>
<!--- Code 3 of 9 representation --->
<CFSET ThreeOfNine=ArrayNew(2)>
<CFSET TNL=ArrayNew(2)>
<cfset ThreeOfNine[01]=ListToArray("1,0,0,1,0,0,0,0,1")> <!--- Code39 Character 1 --->
<cfset ThreeOfNine[02]=ListToArray("0,0,1,1,0,0,0,0,1")> <!--- Code39 Character 2 --->
<cfset ThreeOfNine[03]=ListToArray("1,0,1,1,0,0,0,0,0")> <!--- Code39 Character 3 --->
<cfset ThreeOfNine[04]=ListToArray("0,0,0,1,1,0,0,0,1")> <!--- Code39 Character 4 --->
<cfset ThreeOfNine[05]=ListToArray("1,0,0,1,1,0,0,0,0")> <!--- Code39 Character 5 --->
<cfset ThreeOfNine[06]=ListToArray("0,0,1,1,1,0,0,0,0")> <!--- Code39 Character 6 --->
<cfset ThreeOfNine[07]=ListToArray("0,0,0,1,0,0,1,0,1")> <!--- Code39 Character 7 --->
<cfset ThreeOfNine[08]=ListToArray("1,0,0,1,0,0,1,0,0")> <!--- Code39 Character 8 --->
<cfset ThreeOfNine[09]=ListToArray("0,0,1,1,0,0,1,0,0")> <!--- Code39 Character 9 --->
<cfset ThreeOfNine[10]=ListToArray("0,0,0,1,1,0,1,0,0")> <!--- Code39 Character 0 --->
<cfset ThreeOfNine[11]=ListToArray("1,0,0,0,0,1,0,0,1")> <!--- Code39 Character A --->
<cfset ThreeOfNine[12]=ListToArray("0,0,1,0,0,1,0,0,1")> <!--- Code39 Character B --->
<cfset ThreeOfNine[13]=ListToArray("1,0,1,0,0,1,0,0,0")> <!--- Code39 Character C --->
<cfset ThreeOfNine[14]=ListToArray("0,0,0,0,1,1,0,0,1")> <!--- Code39 Character D --->
<cfset ThreeOfNine[15]=ListToArray("1,0,0,0,1,1,0,0,0")> <!--- Code39 Character E --->
<cfset ThreeOfNine[16]=ListToArray("0,0,1,0,1,1,0,0,0")> <!--- Code39 Character F --->
<cfset ThreeOfNine[17]=ListToArray("0,0,0,0,0,1,1,0,1")> <!--- Code39 Character G --->
<cfset ThreeOfNine[18]=ListToArray("1,0,0,0,0,1,1,0,0")> <!--- Code39 Character H --->
<cfset ThreeOfNine[19]=ListToArray("0,0,1,0,0,1,1,0,0")> <!--- Code39 Character I --->
<cfset ThreeOfNine[20]=ListToArray("0,0,0,0,1,1,1,0,0")> <!--- Code39 Character J --->
<cfset ThreeOfNine[21]=ListToArray("1,0,0,0,0,0,0,1,1")> <!--- Code39 Character K --->
<cfset ThreeOfNine[22]=ListToArray("0,0,1,0,0,0,0,1,1")> <!--- Code39 Character L --->
<cfset ThreeOfNine[23]=ListToArray("1,0,1,0,0,0,0,1,0")> <!--- Code39 Character M --->
<cfset ThreeOfNine[24]=ListToArray("0,0,0,0,1,0,0,1,1")> <!--- Code39 Character N --->
<cfset ThreeOfNine[25]=ListToArray("1,0,0,0,1,0,0,1,0")> <!--- Code39 Character O --->
<cfset ThreeOfNine[26]=ListToArray("0,0,1,0,1,0,0,1,0")> <!--- Code39 Character P --->
<cfset ThreeOfNine[27]=ListToArray("0,0,0,0,0,0,1,1,1")> <!--- Code39 Character Q --->
<cfset ThreeOfNine[28]=ListToArray("1,0,0,0,0,0,1,1,0")> <!--- Code39 Character R --->
<cfset ThreeOfNine[29]=ListToArray("0,0,1,0,0,0,1,1,0")> <!--- Code39 Character S --->
<cfset ThreeOfNine[30]=ListToArray("0,0,0,0,1,0,1,1,0")> <!--- Code39 Character T --->
<cfset ThreeOfNine[31]=ListToArray("1,1,0,0,0,0,0,0,1")> <!--- Code39 Character U --->
<cfset ThreeOfNine[32]=ListToArray("0,1,1,0,0,0,0,0,1")> <!--- Code39 Character V --->
<cfset ThreeOfNine[33]=ListToArray("1,1,1,0,0,0,0,0,0")> <!--- Code39 Character W --->
<cfset ThreeOfNine[34]=ListToArray("0,1,0,0,1,0,0,0,1")> <!--- Code39 Character X --->
<cfset ThreeOfNine[35]=ListToArray("1,1,0,0,1,0,0,0,0")> <!--- Code39 Character Y --->
<cfset ThreeOfNine[36]=ListToArray("0,1,1,0,1,0,0,0,0")> <!--- Code39 Character Z --->
<cfset ThreeOfNine[37]=ListToArray("0,1,0,0,0,0,1,0,1")> <!--- Code39 Character - --->
<cfset ThreeOfNine[38]=ListToArray("1,1,0,0,0,0,1,0,0")> <!--- Code39 Character . --->
<cfset ThreeOfNine[39]=ListToArray("0,1,1,0,0,0,1,0,0")> <!--- Code39 Character (space) --->
<cfset ThreeOfNine[40]=ListToArray("0,1,0,0,1,0,1,0,0")> <!--- Code39 Start/Stop Character --->
<cfset ThreeOfNine[41]=ListToArray("0,1,0,1,0,1,0,0,0")> <!--- Code39 Character $ --->
<cfset ThreeOfNine[42]=ListToArray("0,1,0,1,0,0,0,1,0")> <!--- Code39 Character / --->
<cfset ThreeOfNine[43]=ListToArray("0,1,0,0,0,1,0,1,0")> <!--- Code39 Character + (LowerCase) --->
<cfset ThreeOfNine[44]=ListToArray("0,0,0,1,0,1,0,1,0")> <!--- Code39 Character % --->

<cfset TNL[01]=ListToArray("!,2,42,11")>
<CFSET TNL[02][01]=""><CFSET TNL[02][02]=2><CFSET TNL[02][03]=42><CFSET TNL[02][04]=12>
<CFSET TNL[03][01]=""><CFSET TNL[03][02]=2><CFSET TNL[03][03]=42><CFSET TNL[03][04]=13>
<cfset TNL[04]=ListToArray("$,1,41,14")>
<cfset TNL[05]=ListToArray("%,1,44,15")>
<cfset TNL[06]=ListToArray("&,2,42,16")>
<cfset TNL[07]=ListToArray("',2,42,17")>
<cfset TNL[08]=ListToArray("(,2,42,18")>
<cfset TNL[09]=ListToArray("),2,42,19")>
<cfset TNL[10]=ListToArray("*,2,42,20")>
<cfset TNL[11]=ListToArray("+,2,42,21")>
<cfset TNL[12]=ListToArray(",|2|42|22","|")>
<cfset TNL[13]=ListToArray("-,1,37")>
<cfset TNL[14]=ListToArray(".,1,38")>
<cfset TNL[15]=ListToArray("/,2,42,25")>
<cfset TNL[16]=ListToArray("0,1,10")>
<cfset TNL[17]=ListToArray("1,1,1")>
<cfset TNL[18]=ListToArray("2,1,2")>
<cfset TNL[19]=ListToArray("3,1,3")>
<cfset TNL[20]=ListToArray("4,1,4")>
<cfset TNL[21]=ListToArray("5,1,5")>
<cfset TNL[22]=ListToArray("6,1,6")>
<cfset TNL[23]=ListToArray("7,1,7")>
<cfset TNL[24]=ListToArray("8,1,8")>
<cfset TNL[25]=ListToArray("9,1,9")>
<cfset TNL[26]=ListToArray(":,2,42,36")>
<cfset TNL[27]=ListToArray(";,2,44,16")>
<cfset TNL[28]=ListToArray("<,2,44,17")>
<cfset TNL[29]=ListToArray("=,2,44,18")>
<cfset TNL[30]=ListToArray(">,2,44,19")>
<cfset TNL[31]=ListToArray("?,2,44,20")>
<cfset TNL[32]=ListToArray("@,2,44,32")>
<cfset TNL[33]=ListToArray("A,1,11")>
<cfset TNL[34]=ListToArray("B,1,12")>
<cfset TNL[35]=ListToArray("C,1,13")>
<cfset TNL[36]=ListToArray("D,1,14")>
<cfset TNL[37]=ListToArray("E,1,15")>
<cfset TNL[38]=ListToArray("F,1,16")>
<cfset TNL[39]=ListToArray("G,1,17")>
<cfset TNL[40]=ListToArray("H,1,18")>
<cfset TNL[41]=ListToArray("I,1,19")>
<cfset TNL[42]=ListToArray("J,1,20")>
<cfset TNL[43]=ListToArray("K,1,21")>
<cfset TNL[44]=ListToArray("L,1,22")>
<cfset TNL[45]=ListToArray("M,1,23")>
<cfset TNL[46]=ListToArray("N,1,24")>
<cfset TNL[47]=ListToArray("O,1,25")>
<cfset TNL[48]=ListToArray("P,1,26")>
<cfset TNL[49]=ListToArray("Q,1,27")>
<cfset TNL[50]=ListToArray("R,1,28")>
<cfset TNL[51]=ListToArray("S,1,29")>
<cfset TNL[52]=ListToArray("T,1,30")>
<cfset TNL[53]=ListToArray("U,1,31")>
<cfset TNL[54]=ListToArray("V,1,32")>
<cfset TNL[55]=ListToArray("W,1,33")>
<cfset TNL[56]=ListToArray("X,1,34")>
<cfset TNL[57]=ListToArray("Y,1,35")>
<cfset TNL[58]=ListToArray("Z,1,36")>
<cfset TNL[59]=ListToArray("[,2,44,21")>
<cfset TNL[60]=ListToArray("\,2,44,22")>
<cfset TNL[61]=ListToArray("],2,44,23")>
<cfset TNL[62]=ListToArray("^,2,44,24")>
<cfset TNL[63]=ListToArray("_,2,44,25")>
<cfset TNL[64]=ListToArray("`,2,44,33")>
<cfset TNL[65]=ListToArray("{,2,44,26")>
<cfset TNL[66]=ListToArray("|,2,44,27")>
<cfset TNL[67]=ListToArray("},2,44,28")>
<cfset TNL[68]=ListToArray("~,2,44,29")>
<cfset TNL[69]=ListToArray("[,2,44,21")>
<CFSET TNL[70][1]=" ">
<CFSET TNL[70][2]=1>
<CFSET TNL[70][3]=39>

<CFSET Code39ThickWidth=Attributes.ThinWidth * 3>
<CFSET Code39ThinWidth=Attributes.ThinWidth>
  <!--- Code39 Start Character --->
  <CFLOOP index="t" from="1" to="9">
    <CFIF t mod 2 eq 1>
      <CFIF ThreeOfNine[40][t] eq 1>
        <!--- Thick Bar --->
      	<CFOUTPUT><img width="4" SRC="#Attributes.ImageDir#code39thickbar.gif" height="#Attributes.Height#"></cfoutput>
      <CFELSE>
        <!--- Thin Bar --->
      	<CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
      </cfif>
    <CFELSE>
      <CFIF ThreeOfNine[40][t] eq 1>
        <!--- Thick Space --->
    	  <CFOUTPUT><img width="4" SRC="#Attributes.ImageDir#code39thickspace.gif" height="#Attributes.Height#"></cfoutput>
      <CFELSE>
        <!--- Thin Space --->
    	  <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
      </cfif>
    </cfif>
  </CFLOOP>
  <!--- Inter character gap --->
  <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
  <CFLOOP index="c" from="1" to="#len(Attributes.BarCode)#">
    <!--- Grab the character and find the number of elements to --->
    <!--- make up this character                                --->
    <CFSET char = mid(Attributes.BarCode,c,1)>
    <CFLOOP index="cc" from="1" to="70">
      <CFIF TNL[cc][1] eq "#UCase(char)#">
        <CFSET ndx=cc>
        <CFBREAK>
      </cfif>
    </cfloop>
  
    <!--- Add lower case character --->
    <CFIF Asc(char) gte Asc("a") AND Asc(char) lte Asc("z")>
      <CFLOOP index="t" from="1" to="9">
      <CFIF t mod 2 eq 1>
        <CFIF ThreeOfNine[40][t] eq 1>
          <!--- Thick Bar --->
	        <CFOUTPUT><img width="4" SRC="#Attributes.ImageDir#code39thickbar.gif" height="#Attributes.Height#"></cfoutput>
        <CFELSE>
          <!--- Thin Bar --->
	        <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
        </cfif>
      <CFELSE>
        <CFIF ThreeOfNine[40][t] eq 1>
          <!--- Thick Space --->
	        <CFOUTPUT><img width="4" SRC="#Attributes.ImageDir#code39thickspace.gif" height="#Attributes.Height#"></cfoutput>
        <CFELSE>
          <!--- Thin Space --->
	        <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
        </cfif>
      </cfif>
      </CFLOOP>
      <!--- Inter character gap --->
      <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
    </cfif>
  
    <CFLOOP index="CharacterCounter" from="1" to="#TNL[ndx][2]#">
    <CFSET Character=CharacterCounter+2>
      <CFLOOP index="t" from="1" to="9">
        <CFIF t mod 2 eq 1> 
          <CFIF ThreeOfNine[TNL[ndx][Character]][t] eq 1>
            <!--- Thick Bar --->
            <CFOUTPUT><img width="4" SRC="#Attributes.ImageDir#code39thickbar.gif" height="#Attributes.Height#"></cfoutput>
          <CFELSE>
            <!--- Thin Bar --->
            <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
          </cfif>
        <CFELSE>
          <CFIF ThreeOfNine[TNL[ndx][Character]][t] eq 1>
            <!--- Thick Space --->
            <CFOUTPUT><img width="4" SRC="#Attributes.ImageDir#code39thickspace.gif" height="#Attributes.Height#"></cfoutput>
          <CFELSE>
            <!--- Thin Space --->
            <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
          </cfif>
        </cfif>
      </CFLOOP>
      <!--- Inter character gap --->
      <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
    </CFLOOP>
  </CFLOOP>
  
  <!--- Code39 Stop Character --->
  <CFLOOP index="t" from="1" to="9">
    <CFIF t mod 2 eq 1>
      <CFIF ThreeOfNine[40][t] eq 1>
        <!--- Thick Bar --->
    	  <CFOUTPUT><img width="4"  SRC="#Attributes.ImageDir#code39thickbar.gif" height="#Attributes.Height#"></cfoutput>
      <CFELSE>
        <!--- Thin Bar --->
    	  <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
      </cfif>
    <CFELSE>
      <CFIF ThreeOfNine[40][t] eq 1>
        <!--- Thick Space --->
    	  <CFOUTPUT><img width="4" SRC="#Attributes.ImageDir#code39thickspace.gif" height="#Attributes.Height#"></cfoutput>
      <CFELSE>
        <!--- Thin Space --->
    	  <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
      </cfif>
    </cfif>
  </CFLOOP>
  <!--- Inter character gap --->
  <CFOUTPUT><img width="2" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
</CFIF>

<!--- PostNet --->
<!--- PostNet --->
<CFIF Attributes.BarCodeType eq 4>
<!--- PostNet Character Representation --->
<CFSET PostNet=ArrayNew(2)>
<CFSET PostNet[1]=ListToArray("1,1,0,0,0")><!--- Character 0 --->
<CFSET PostNet[2]=ListToArray("0,0,0,1,1")><!--- Character 1 --->
<CFSET PostNet[3]=ListToArray("0,0,1,0,1")><!--- character 2 --->
<CFSET PostNet[4]=ListToArray("0,0,1,1,0")><!--- Character 3 --->
<CFSET PostNet[5]=ListToArray("0,1,0,0,1")><!--- Character 4 --->
<CFSET PostNet[6]=ListToArray("0,1,0,1,0")><!--- Character 5 --->
<CFSET PostNet[7]=ListToArray("0,1,1,0,0")><!--- Character 6 --->
<CFSET PostNet[8]=ListToArray("1,0,0,0,1")><!--- Character 7 --->
<CFSET PostNet[9]=ListToArray("1,0,0,1,0")><!--- Character 8 --->
<CFSET PostNet[10]=ListToArray("1,0,1,0,0")><!--- Character 9 --->

<CFLOOP index="c" from="1" to="#len(Attributes.BarCode)#">
  <CFSET char = mid(Attributes.BarCode,c,1) + 1>
  <CFLOOP index="t" from="1" to="5"> <!--- Character generation --->
    <CFIF PostNet[char][t] is 1>
  	    <cfset ht="30">
	  <CFELSE>
	    <CFSET ht="15">
	</CFIF>
   <cfoutput><img width="2" SRC="#Attributes.ImageDir#thickbar.gif" height="#ht#"><img width="2" SRC="#Attributes.ImageDir#thickspace.gif"></cfoutput>
  </CFLOOP>
</CFLOOP>
</cfif>

<!--- Codabar --->
<CFIF Attributes.BarcodeType eq 5>
<CFSET Codabar=ArrayNew(2)>
<CFSET Codabar[1]=ListToArray("0,0,0,0,0,0,1,1")> <!--- Character 0 --->
<CFSET Codabar[2]=ListToArray("1,0,0,0,0,1,0,1")> <!--- Character 1 --->
<CFSET Codabar[3]=ListToArray("2,0,0,0,1,0,1,0")> <!--- Character 2 --->
<CFSET Codabar[4]=ListToArray("3,1,1,0,0,0,0,0")> <!--- Character 3 --->
<CFSET Codabar[5]=ListToArray("4,0,0,1,0,0,1,0")> <!--- Character 4 --->
<CFSET Codabar[6]=ListToArray("5,1,0,0,0,0,1,0")> <!--- Character 5 --->
<CFSET Codabar[7]=ListToArray("6,0,1,0,0,0,0,1")> <!--- Character 6 --->
<CFSET Codabar[8]=ListToArray("7,0,1,0,0,1,0,0")> <!--- Character 7 --->
<CFSET Codabar[9]=ListToArray("8,0,1,1,0,0,0,0")> <!--- Character 8 --->
<CFSET Codabar[10]=ListToArray("9,1,0,0,1,0,0,0")> <!--- Character 9 --->
<CFSET Codabar[11]=ListToArray("-,0,0,0,1,1,0,0")> <!--- Character - --->
<CFSET Codabar[12]=ListToArray("$,0,0,1,1,0,0,0")> <!--- Character $ --->
<CFSET Codabar[13]=ListToArray(":,1,0,0,0,1,0,1")> <!--- Character : --->
<CFSET Codabar[14]=ListToArray("/,1,0,1,0,0,0,1")> <!--- Character / --->
<CFSET Codabar[15]=ListToArray(".,1,0,1,0,1,0,0")> <!--- Character . --->
<CFSET Codabar[16]=ListToArray("+,0,0,1,0,1,0,1")> <!--- Character + --->
<CFSET Codabar[17]=ListToArray("a,0,0,1,1,0,1,0")> <!--- Character a --->
<CFSET Codabar[18]=ListToArray("b,0,1,0,1,0,0,1")> <!--- Character b --->
<CFSET Codabar[19]=ListToArray("c,0,0,0,1,0,1,1")> <!--- Character c --->
<CFSET Codabar[20]=ListToArray("d,0,0,0,1,1,1,0")> <!--- Character d --->

  <CFLOOP index="c" from="1" to="#len(Attributes.BarCode)#">
    <!--- Grab the character and find the number of elements to --->
    <!--- make up this character                                --->
    <CFSET char = mid(Attributes.BarCode,c,1)>
    <CFLOOP index="cc" from="1" to="70">
      <CFIF Codabar[cc][1] eq "#UCase(char)#">
        <CFSET ndx=cc>
        <CFBREAK>
      </cfif>
    </cfloop>
    <!--- Generate the character --->
    <CFLOOP index="t" from="2" to="8">
    <CFIF t mod 2 eq 1>
      <CFIF Codabar[ndx][t] eq 1>
        <!--- Thick Bar --->
      	<CFOUTPUT><img width="#Attributes.ThickWidth#" SRC="#Attributes.ImageDir#thickspace.gif" height="#Attributes.Height#"></cfoutput>
      <CFELSE>
        <!--- Thin Bar --->
      	<CFOUTPUT><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
      </cfif>
    <CFELSE>
      <CFIF Codabar[ndx][t] eq 1>
        <!--- Thick Space --->
    	  <CFOUTPUT><img width="#Attributes.ThickWidth#" SRC="#Attributes.ImageDir#thickbar.gif" height="#Attributes.Height#"></cfoutput>
      <CFELSE>
        <!--- Thin Space --->
    	  <CFOUTPUT><img width="#Attributes.ThinWidth#" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
      </cfif>
    </cfif>
	</cfloop>
</CFLOOP>
</cfif>

<!--- UPC(e) --->
<!--- UPC(e) --->
<CFIF Attributes.BarcodeType eq 6>
<CFSET UPC_E=ArrayNew(2)>
<CFSET UPC_CheckCode=ArrayNew(2)>

<!--- 1=Even, 0=Odd --->
<CFSET UPC_CheckCode[1]=ListToArray("1,1,1,0,0,0")>
<CFSET UPC_CheckCode[2]=ListToArray("1,1,0,1,0,0")>
<CFSET UPC_CheckCode[3]=ListToArray("1,1,0,0,1,0,")>
<CFSET UPC_CheckCode[4]=ListToArray("1,1,0,0,0,1,")>
<CFSET UPC_CheckCode[5]=ListToArray("1,0,1,1,0,0,")>
<CFSET UPC_CheckCode[6]=ListToArray("1,0,0,1,1,0,")>
<CFSET UPC_CheckCode[7]=ListToArray("1,0,0,0,1,1,")>
<CFSET UPC_CheckCode[8]=ListToArray("1,0,1,0,1,0,")>
<CFSET UPC_CheckCode[9]=ListToArray("1,0,1,0,0,1,")>
<CFSET UPC_CheckCode[10]=ListToArray("1,0,0,1,0,1,")>

<CFSET UPC_E[1]=ListToArray("0,0,0,1,1,0,1,0,1,0,0,1,1,1")>
<CFSET UPC_E[2]=ListToArray("0,0,1,1,0,0,1,0,1,1,0,0,1,1")>
<CFSET UPC_E[3]=ListToArray("0,0,1,0,0,1,1,0,0,1,1,0,1,1")>
<CFSET UPC_E[4]=ListToArray("0,1,1,1,1,0,1,0,1,0,0,0,0,1")>
<CFSET UPC_E[5]=ListToArray("0,1,0,0,0,1,1,0,0,1,1,1,0,1")>
<CFSET UPC_E[6]=ListToArray("0,1,1,0,0,0,1,0,1,1,1,0,0,1")>
<CFSET UPC_E[7]=ListToArray("0,1,0,1,1,1,1,0,0,0,0,1,0,1")>
<CFSET UPC_E[8]=ListToArray("0,1,1,1,0,1,1,0,0,1,0,0,0,1")>
<CFSET UPC_E[9]=ListToArray("0,1,1,0,1,1,1,0,0,0,1,0,0,1")>
<CFSET UPC_E[10]=ListToArray("0,0,0,1,0,1,1,0,0,1,0,1,1,1")>

<CFSET M1=0>
<!--- 10-( ((1,3,5)*3) + (2,4,6)) MOD 10) --->
<CFLOOP index="BCG_c" from="1" to="5" step="2">
<CFSET M1=M1+val(mid(Attributes.BarCode,BCG_c,1))>
</cfloop>
<CFSET M1=M1*3>
<CFLOOP index="BCG_c" from="2" to="6" step="2">
<CFSET M1=M1+val(mid(Attributes.BarCode,BCG_c,1))>
</cfloop>
<CFSET BCG_Check_Char=(10 - (M1 MOD 10))+1>
<!--- Guard bars --->
<CFSET TrueDescender=(Attributes.height * 0.1)+Attributes.height>
<CFOUTPUT><IMG  width="2" align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><IMG  width="2" align="texttop" SRC="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><IMG  width="2" align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"></CFOUTPUT>

<CFLOOP index="BCG_c" from="1" to="6">
<CFSET BCG_char=mid(Attributes.BarCode,BCG_c,1)+1>
<CFSET BCG_Offset=UPC_CheckCode[BCG_Check_Char][BCG_c] * 7>

  <CFLOOP index="BCG_l" from="1" to="7">
    <CFIF UPC_E[BCG_char][BCG_Offset+BCG_l] eq 1>
       <CFOUTPUT><IMG   width="2" align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#Attributes.height#"></CFOUTPUT>
	<CFELSE>
       <CFOUTPUT><IMG   width="2" align="texttop" SRC="#Attributes.ImageDir#thinspace.gif" height="#Attributes.height#"></CFOUTPUT>
	</cfif>
  </CFLOOP>
</cfloop>

<!--- Guard bars --->
<CFOUTPUT><IMG  width="2" align="texttop"  SRC="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><IMG  width="2" align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><IMG   width="2" align="texttop" SRC="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><IMG   width="2" align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><IMG   width="2" align="texttop" SRC="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><IMG   width="2" align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"></CFOUTPUT>
</CFIF>

<!--- UPC(a) --->
<CFIF Attributes.BarcodeType eq 7>
<CFSET UPC_A=ArrayNew(2)>

<CFSET UPC_A[1] =ListToArray("0,0,0,1,1,0,1,1,1,1,0,0,1,0")>
<CFSET UPC_A[2] =ListToArray("0,0,1,1,0,0,1,1,1,0,0,1,1,0")>
<CFSET UPC_A[3] =ListToArray("0,0,1,0,0,1,1,1,1,0,1,1,0,0")>
<CFSET UPC_A[4] =ListToArray("0,1,1,1,1,0,1,1,0,0,0,0,1,0")>
<CFSET UPC_A[5] =ListToArray("0,1,0,0,0,1,1,1,0,1,1,1,0,0")>
<CFSET UPC_A[6] =ListToArray("0,1,1,0,0,0,1,1,0,0,1,1,1,0")>
<CFSET UPC_A[7] =ListToArray("0,1,0,1,1,1,1,1,0,1,0,0,0,0")>
<CFSET UPC_A[8] =ListToArray("0,1,1,1,0,1,1,1,0,0,0,1,0,0")>
<CFSET UPC_A[9] =ListToArray("0,1,1,0,1,1,1,1,0,0,1,0,0,0")>
<CFSET UPC_A[10]=ListToArray("0,0,0,1,0,1,1,1,1,1,0,1,0,0")>

<!--- Guard bars --->
<CFSET TrueDescender=(Attributes.height * 0.15)+Attributes.height>
<CFOUTPUT><IMG align="texttop"  width="1" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"  width="2" ><IMG  align="texttop"  width="1" SRC="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><IMG  align="texttop"  width="1" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"></CFOUTPUT>
<CFLOOP index="BCG_c" from="1" to="12">
<CFSET BCG_char=mid(Attributes.BarCode,BCG_c,1)+1>
<CFSET BCG_Offset=((BCG_c \ 7) * 7)>
<!--- First and Last Character uses True-Descenders --->
    <CFIF ( (BCG_c eq 1) OR (BCG_c eq 12) )>
      <CFSET BarHeight=(Attributes.height * 0.15)+Attributes.height>
    <CFELSE>
      <CFSET BarHeight=Attributes.height>
    </cfif>
  <CFLOOP index="BCG_l" from="1" to="7">
    <CFIF UPC_A[BCG_char][BCG_Offset+BCG_l] eq 1>
       <CFOUTPUT><IMG  width="1"  align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#BarHeight#"></CFOUTPUT>
	<CFELSE>
       <CFOUTPUT><IMG  width="1"  align="texttop" SRC="#Attributes.ImageDir#thinspace.gif" height="#BarHeight#"></CFOUTPUT>
	</cfif>
  </CFLOOP>
  <!--- Center Bars --->
  <CFIF BCG_c eq 6>
  <CFOUTPUT><IMG  width="1"  align="texttop" SRC="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><IMG  width="1"  align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><IMG  width="1"  align="texttop" SRC="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><IMG  width="1"  align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><IMG  width="1"  align="texttop" SRC="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"></cfoutput>
  </cfif>
</cfloop>

<!--- Guard bars --->
<CFOUTPUT><IMG  width="1" align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"><IMG   width="1" align="texttop" SRC="#Attributes.ImageDir#thinspace.gif" height="#TrueDescender#"><IMG   width="1" align="texttop" SRC="#Attributes.ImageDir#thinbar.gif" height="#TrueDescender#"></CFOUTPUT>
</CFIF>



<!--- Code128 --->
<CFSET Code128=ArrayNew(2)>
<CFSET The128Code=ArrayNew(1)>
<CFSET Code128[1]=ListToArray(" ,2,1,2,2,2,2",",",true)> <!--- (space) (space) 00 --->
<CFSET Code128[2]=ListToArray("!,2,2,2,1,2,2",",",true)> <!---    !       !    01 --->
<!---
<CFSET Code128[3]=ListToArray(" ,2,1,2,2,2,2",",",true)>
<CFSET Code128[4]=ListToArray(" ,2,1,2,2,2,2",",",true)>
--->
<CFSET Code128[3]=ListToArray(" ,2,2,2,2,2,1",",",true)>
<CFSET Code128[4]=ListToArray(" ,1,2,1,2,2,3",",",true)>
<CFSET Code128[5]=ListToArray("$,1,2,1,3,2,2",",",true)>
<CFSET Code128[6]=ListToArray("%,1,3,1,2,2,2",",",true)>
<CFSET Code128[7]=ListToArray("&,1,2,2,2,1,3",",",true)>
<CFSET Code128[8]=ListToArray("',1,2,2,3,1,2",",",true)>
<CFSET Code128[9]=ListToArray ("(,1,3,2,2,1,2",",",true)>
<CFSET Code128[10]=ListToArray("),2,2,1,2,1,3",",",true)>
<CFSET Code128[11]=ListToArray("*,2,2,1,3,1,2",",",true)>
<CFSET Code128[12]=ListToArray("+,2,3,1,2,1,2",",",true)>
<CFSET Code128[13]=ListToArray("',1,1,2,2,3,2",",",true)>
<CFSET Code128[14]=ListToArray("-,1,2,2,1,3,2",",",true)>
<CFSET Code128[15]=ListToArray(".,1,2,2,2,3,1",",",true)>
<CFSET Code128[16]=ListToArray("/,1,1,3,2,2,2",",",true)>
<CFSET Code128[17]=ListToArray("0,1,2,3,1,2,2",",",true)>
<CFSET Code128[18]=ListToArray("1,1,2,3,2,2,1",",",true)>
<CFSET Code128[19]=ListToArray("2,2,2,3,2,1,1",",",true)>
<CFSET Code128[20]=ListToArray("3,2,2,1,1,3,2",",",true)>
<CFSET Code128[21]=ListToArray("4,2,2,1,2,3,1",",",true)>
<CFSET Code128[22]=ListToArray("5,2,1,3,2,1,2",",",true)>
<CFSET Code128[23]=ListToArray("6,2,2,3,1,1,2",",",true)>
<CFSET Code128[24]=ListToArray("7,3,1,2,1,3,1",",",true)>
<CFSET Code128[25]=ListToArray("8,3,1,1,2,2,2",",",true)>
<CFSET Code128[26]=ListToArray("9,3,2,1,1,2,2",",",true)>
<CFSET Code128[27]=ListToArray(":,3,2,1,2,2,1",",",true)>
<CFSET Code128[28]=ListToArray(";,3,1,2,2,1,2",",",true)>
<CFSET Code128[29]=ListToArray("<,3,2,2,1,1,2",",",true)>
<CFSET Code128[30]=ListToArray("=,3,2,2,2,1,1",",",true)>
<CFSET Code128[31]=ListToArray(">,2,1,2,1,2,3",",",true)>
<CFSET Code128[32]=ListToArray("?,2,1,2,3,2,1",",",true)>
<CFSET Code128[33]=ListToArray("@,2,3,2,1,2,1",",",true)>
<CFSET Code128[34]=ListToArray("A,1,1,1,3,2,3",",",true)>
<CFSET Code128[35]=ListToArray("B,1,3,1,1,2,3",",",true)>
<CFSET Code128[36]=ListToArray("C,1,3,1,3,2,1",",",true)>
<CFSET Code128[37]=ListToArray("D,1,1,2,3,1,3",",",true)>
<CFSET Code128[38]=ListToArray("E,1,3,2,1,1,3",",",true)>
<CFSET Code128[39]=ListToArray("F,1,3,2,3,1,1",",",true)>
<CFSET Code128[40]=ListToArray("G,2,1,1,3,1,3",",",true)>
<CFSET Code128[41]=ListToArray("H,2,3,1,1,1,3",",",true)>
<CFSET Code128[42]=ListToArray("I,2,3,1,3,1,1",",",true)>
<CFSET Code128[43]=ListToArray("J,1,1,2,1,3,3",",",true)>
<CFSET Code128[44]=ListToArray("K,1,1,2,3,3,1",",",true)>
<CFSET Code128[45]=ListToArray("L,1,3,2,1,3,1",",",true)>
<CFSET Code128[46]=ListToArray("M,1,1,3,1,2,3",",",true)>
<CFSET Code128[47]=ListToArray("N,1,1,3,3,2,1",",",true)>
<CFSET Code128[48]=ListToArray("O,1,3,3,1,2,1",",",true)>
<CFSET Code128[49]=ListToArray("P,3,1,3,1,2,1",",",true)>
<CFSET Code128[50]=ListToArray("Q,2,1,1,3,3,1",",",true)>
<CFSET Code128[51]=ListToArray("R,2,3,1,1,3,1",",",true)>
<CFSET Code128[52]=ListToArray("S,2,1,3,1,1,3",",",true)>
<CFSET Code128[53]=ListToArray("T,2,1,3,3,1,1",",",true)>
<CFSET Code128[54]=ListToArray("U,2,1,3,1,3,1",",",true)>
<CFSET Code128[55]=ListToArray("V,3,1,1,1,2,3",",",true)>
<CFSET Code128[56]=ListToArray("W,3,1,1,3,2,1",",",true)>
<CFSET Code128[57]=ListToArray("X,3,3,1,1,2,1",",",true)>
<CFSET Code128[58]=ListToArray("Y,3,1,2,1,1,3",",",true)>
<CFSET Code128[59]=ListToArray("Z,3,1,2,3,1,1",",",true)>
<CFSET Code128[60]=ListToArray("[,3,3,2,1,1,1",",",true)>
<CFSET Code128[61]=ListToArray("\,3,1,4,1,1,1",",",true)>
<CFSET Code128[62]=ListToArray("],2,2,1,4,1,1",",",true)>
<CFSET Code128[63]=ListToArray("^,4,3,1,1,1,1",",",true)>
<CFSET Code128[64]=ListToArray("_,1,1,1,2,2,4",",",true)>
<CFSET Code128[65]=ListToArray("`,1,1,1,4,2,2",",",true)>
<CFSET Code128[66]=ListToArray("a,1,2,1,1,2,4",",",true)>
<CFSET Code128[67]=ListToArray("b,1,2,1,4,2,1",",",true)>
<CFSET Code128[68]=ListToArray("c,1,4,1,1,2,2",",",true)>
<CFSET Code128[69]=ListToArray("d,1,4,1,2,2,1",",",true)>
<CFSET Code128[70]=ListToArray("e,1,1,2,2,1,4",",",true)>
<CFSET Code128[71]=ListToArray("f,1,1,2,4,1,2",",",true)>
<CFSET Code128[72]=ListToArray("g,1,2,2,1,1,4",",",true)>
<CFSET Code128[73]=ListToArray("h,1,2,2,4,1,1",",",true)>
<CFSET Code128[74]=ListToArray("i,1,4,2,1,1,2",",",true)>
<CFSET Code128[75]=ListToArray("j,1,4,2,2,1,1",",",true)>
<CFSET Code128[76]=ListToArray("k,2,4,1,2,1,1",",",true)>
<CFSET Code128[77]=ListToArray("l,2,2,1,1,1,4",",",true)>
<CFSET Code128[78]=ListToArray("m,4,1,3,1,1,1",",",true)>
<CFSET Code128[79]=ListToArray("n,2,4,1,1,1,2",",",true)>
<CFSET Code128[80]=ListToArray("o,1,3,4,1,1,1",",",true)>
<CFSET Code128[81]=ListToArray("p,1,1,1,2,4,2",",",true)>
<CFSET Code128[82]=ListToArray("q,1,2,1,1,4,2",",",true)>
<CFSET Code128[83]=ListToArray("r,1,2,1,2,4,1",",",true)>
<CFSET Code128[84]=ListToArray("s,1,1,4,2,1,2",",",true)>
<CFSET Code128[85]=ListToArray("t,1,2,4,1,1,2",",",true)>
<CFSET Code128[86]=ListToArray("u,1,2,4,2,1,1",",",true)>
<CFSET Code128[87]=ListToArray("v,4,1,1,2,1,2",",",true)>
<CFSET Code128[88]=ListToArray("w,4,2,1,1,1,2",",",true)>
<CFSET Code128[89]=ListToArray("x,4,2,1,2,1,1",",",true)>
<CFSET Code128[90]=ListToArray("y,2,1,2,1,4,1",",",true)>
<CFSET Code128[91]=ListToArray("z,2,1,4,1,2,1",",",true)>
<CFSET Code128[92]=ListToArray("{,4,1,2,1,2,1",",",true)>
<CFSET Code128[93]=ListToArray("|,1,1,1,1,4,3",",",true)>
<CFSET Code128[94]=ListToArray("},1,1,1,3,4,1",",",true)>
<CFSET Code128[95]=ListToArray("~,1,3,1,1,4,1",",",true)>
<CFSET Code128[96]=ListToArray("^_,1,1,4,1,1,3",",",true)>
<CFSET Code128[97]=ListToArray("FNC3,1,1,4,3,1,1",",",true)>
<CFSET Code128[98]=ListToArray("FNC2,4,1,1,1,1,3",",",true)>
<CFSET Code128[99]=ListToArray("SHIFTB,4,1,1,3,1,1",",",true)>
<CFSET Code128[100]=ListToArray("CODEC,1,1,3,1,4,1",",",true)>
<CFSET Code128[101]=ListToArray("CODEB,1,1,4,1,3,1",",",true)>
<CFSET Code128[102]=ListToArray("FNC4,3,1,1,1,4,1",",",true)>
<CFSET Code128[103]=ListToArray("FNC1,4,1,1,1,3,1",",",true)>
<CFSET Code128[104]=ListToArray("STARTA,2,1,1,4,1,2",",",true)>
<CFSET Code128[105]=ListToArray("STARTB,2,1,1,2,1,4",",",true)>
<CFSET Code128[106]=ListToArray("STARTC,2,1,1,2,3,2",",",true)>
<CFSET Code128[107]=ListToArray("STOP,2,3,3,1,1,1,2",",",true)>

<CFIF Attributes.BarCodeType eq 8>
<!--- By default characterset B --->
<CFSET found=0>
<CFSET swapper=2>
<CFSET ndx=0>
<cfset m=1>



<!--- Start Character --->
		   <CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
		   <CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
           <CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
		   <CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
           <CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
		   <CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>

<!--- FNC 1 --->
<!---
		   <CFOUTPUT><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
		   <CFOUTPUT><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
           <CFOUTPUT><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
		   <CFOUTPUT><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
		   <CFOUTPUT><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
		   <CFOUTPUT><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
 --->
<CFSET Checksum=104>
<!--- Main barcode generator --->
<CFLOOP index="c" from="1" to="#len(Attributes.BarCode)#">
  <CFSET first=#mid(Attributes.BarCode,c,1)#>
    <!--- 100 charcters per character set --->
    <CFLOOP index="i" from="1" to="96">
       <CFIF asc(Code128[i][1]) eq asc(first)>
             <CFSET ndx=i>
             <CFBREAK>
       </CFIF>
    </CFLOOP>

  <!--- Character number is "i" --->
  <!--- Calculate checksum character --->
	<CFSET Checksum=Checksum + (c*(ndx-1))>
      <CFLOOP index="cc" from="2" to="7"> <!--- send the character to the display --->
         <CFIF cc MOD 2 eq 0> <!--- BAR --->
		   <!--- Check width of bars --->
		   <CFLOOP index="BCG_cc" from="1" to="#Code128[ndx][cc]#">
		   <CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
		   </cfloop>
		 <CFELSE>
		   <!--- Check width of spaces --->
		   <CFLOOP index="BCG_cc" from="1" to="#Code128[ndx][cc]#">
		   <CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
		   </cfloop>
		 </cfif>
      </CFLOOP>
</CFLOOP>



<CFSET ndx=(Checksum MOD 103)+1>

<!--- Checksum charcater --->
      <CFLOOP index="cc" from="2" to="7"> <!--- send the character to the display --->
         <CFIF cc MOD 2 eq 0> <!--- BAR --->
		   <!--- Check width of bars --->
		   <CFLOOP index="BCG_cc" from="1" to="#Code128[ndx][cc]#">
		     <CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
		   </cfloop>
		 <CFELSE>
		   <!--- Check width of spaces --->
		   <CFLOOP index="BCG_cc" from="1" to="#Code128[ndx][cc]#">
		     <CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
		   </cfloop>
		 </cfif>
      </CFLOOP>

<CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="#attributes.iWidth#" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
</CFIF>


<!--- Code128 Characterset C --->
<CFIF Attributes.BarCodeType eq 11>
<!--- start C  --->
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
<!--- FNC1
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
 --->
  <CFSET Checksum = 105>
  <CFSET DigitCounter=1>
  <CFLOOP index="c" from="1" to="#len(Attributes.BarCode)#" step="2">
    <CFSET first=#mid(Attributes.BarCode,c,1)#>
    <CFSET thisChar = (first*10) + #mid(Attributes.BarCode,c+1,1)#>
    <CFSET thisChar = thisChar+1>
	<CFSET Checksum=Checksum + (DigitCounter*(thisChar-1))>
    <CFSET DigitCounter=DigitCounter+1>
      <!--- generate the character --->
      <CFLOOP index="cc" from="2" to="7">
      // Send to display
         <CFIF cc MOD 2 eq 0> <!--- BAR --->
		   <!--- Check width of bars --->
           <CFLOOP index="BCG_cc" from="1" to="#Code128[thisChar][cc]#">
		     <CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
           </cfloop>
		 <CFELSE>
		   <!--- Check width of spaces --->
		   <CFLOOP index="BCG_cc" from="1" to="#Code128[thisChar][cc]#">
		     <CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
           </cfloop>
         </cfif>
      </CFLOOP>
      <!--- generate the character --->
  </CFLOOP> <!--- Cycle thru barcode string --->
  <CFSET CheckDigit = (Checksum MOD 103)+1>
  <!--- Generate check digit --->
      <CFLOOP index="cc" from="2" to="7">
      // Send to display
         <CFIF cc MOD 2 eq 0> <!--- BAR --->
		   <!--- Check width of bars --->
           <CFLOOP index="BCG_cc" from="1" to="#Code128[CheckDigit][cc]#">
		     <CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
           </cfloop>
		 <CFELSE>
		   <!--- Check width of spaces --->
		   <CFLOOP index="BCG_cc" from="1" to="#Code128[CheckDigit][cc]#">
		     <CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
           </cfloop>
         </cfif>
      </CFLOOP>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></CFOUTPUT>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
<CFOUTPUT><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"><img width="1" src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
</CFIF>

<!--- EAN --->

<CFIF Attributes.BarCodeType eq 9>
<CFSET EAN=ArrayNew(2)>
<CFSET EANLOOKUP=ArrayNew(2)>

<CFSET EAN[1]=ListToArray("0,0,0,1,1,0,1,0,1,0,0,1,1,1,1,1,1,0,0,1,0")>
<CFSET EAN[2]=ListToArray("0,0,1,1,0,0,1,0,1,1,0,0,1,1,1,1,0,0,1,1,0")>
<CFSET EAN[3]=ListToArray("0,0,1,0,0,1,1,0,0,1,1,0,1,1,1,1,0,1,1,0,0")>
<CFSET EAN[4]=ListToArray("0,1,1,1,1,0,1,0,1,0,0,0,0,1,1,0,0,0,0,1,0")>
<CFSET EAN[5]=ListToArray("0,1,0,0,0,1,1,0,0,1,1,1,0,1,1,0,1,1,1,0,0")>
<CFSET EAN[6]=ListToArray("0,1,1,0,0,0,1,0,1,1,1,0,0,1,1,0,0,1,1,1,0")>
<CFSET EAN[7]=ListToArray("0,1,0,1,1,1,1,0,0,0,0,1,0,1,1,0,1,0,0,0,0")>
<CFSET EAN[8]=ListToArray("0,1,1,1,0,1,1,0,0,1,0,0,0,1,1,0,0,0,1,0,0")>
<CFSET EAN[9]=ListToArray("0,1,1,0,1,1,1,0,0,0,1,0,0,1,1,0,0,1,0,0,0")>
<CFSET EAN[10]=ListToArray("0,0,0,1,0,1,1,0,0,1,0,1,1,1,1,1,1,0,1,0,0")>

<CFSET EANLOOKUP[1]=ListToArray("0,0,0,0,0,0,1,1,1,1,1,1,1")>
<CFSET EANLOOKUP[2]=ListToArray("0,0,1,0,1,1,1,1,1,1,1,1,1")>
<CFSET EANLOOKUP[3]=ListToArray("0,0,1,1,0,1,1,1,1,1,1,1,1")>
<CFSET EANLOOKUP[4]=ListToArray("0,0,1,1,1,0,1,1,1,1,1,1,1")>
<CFSET EANLOOKUP[5]=ListToArray("0,1,0,0,1,1,1,1,1,1,1,1,1")>
<CFSET EANLOOKUP[6]=ListToArray("0,1,1,0,0,1,1,1,1,1,1,1,1")>
<CFSET EANLOOKUP[7]=ListToArray("0,1,1,1,0,0,1,1,1,1,1,1,1")>
<CFSET EANLOOKUP[8]=ListToArray("0,1,0,1,0,1,1,1,1,1,1,1,1")>
<CFSET EANLOOKUP[9]=ListToArray("0,1,0,1,1,0,1,1,1,1,1,1,1")>
<CFSET EANLOOKUP[10]=ListToArray("0,1,1,0,1,0,1,1,1,1,1,1,1")>

<CFSET EANLOOKUPCHAR=Val(left(Attributes.BarCode,1))+1>
<!--- Guard bars --->
      <cfoutput><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
      <cfoutput><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
      <cfoutput><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
<!--- Loop thru the barcode --->
<CFLOOP index="EANCHAR" from="2" to="#Len("#Attributes.BarCode#")#">
  <CFSET EANBarChar=Mid(Attributes.BarCode,EANCHAR,1)+1>
  <!--- <CFOUTPUT>#Evaluate(EANBarChar-1)#</cfoutput> --->
  <CFIF EANCHAR lte 7>
    <CFSET ENL=EANLOOKUP[EANLOOKUPCHAR][EANCHAR-1]>
   <CFELSE>
    <CFSET ENL=2>
  </cfif>
  <CFSET fm=Evaluate((#ENL#*7)+1)>
  <CFSET ft=Evaluate((#ENL#*7)+7)>
  <!--- <CFOUTPUT>-#fm#-#ft#</cfoutput> --->
  <CFLOOP index="ELOOK" from="#fm#" to="#ft#">
    <CFIF EAN[EANBarChar][ELOOK] is 1>
      <cfoutput><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
     <CFELSE>
      <cfoutput><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
    </cfif>
  </cfloop>
  <CFIF EANCHAR eq 7><!--- Middle bars --->
      <!--- <CFOUTPUT>*</cfoutput> --->
      <cfoutput><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
      <cfoutput><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
      <cfoutput><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
      <cfoutput><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
      <cfoutput><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
  </cfif>
</CFLOOP>
<!--- Guard bars --->
      <cfoutput><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>
      <cfoutput><img src="#Attributes.ImageDir#thinspace.gif" height="#Attributes.Height#"></cfoutput>
      <cfoutput><img src="#Attributes.ImageDir#thinbar.gif" height="#Attributes.Height#"></cfoutput>

</CFIF>

<cfsetting enablecfoutputonly="No">
<cfsetting enablecfoutputonly="No">


