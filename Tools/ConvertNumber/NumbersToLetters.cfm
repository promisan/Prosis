<!--
    Copyright Â© 2025 Promisan

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

<cfset Months=ArrayNew(1)>
<cfset Months[1]="enero">
<cfset Months[2]="febrero">
<cfset Months[3]="marzo">
<cfset Months[4]="abril">
<cfset Months[5]="mayo">
<cfset Months[6]="junio">
<cfset Months[7]="julio">
<cfset Months[8]="agosto">
<cfset Months[9]="septiembre">
<cfset Months[10]="octubre">
<cfset Months[11]="noviembre">
<cfset Months[12]="diciembre">

<cfset o = ArrayNew(1)>
<cfset o = ["diez", "once", "doce", "trece", "catorce", "quince", "dieciséis", "diecisiete", "dieciocho", "diecinueve", "veinte", "veintiuno", "veintidós", "veintitrés", "veinticuatro", "veinticinco", "veintiséis", "veintisiete", "veintiocho", "veintinueve"]>

<cfset u = ArrayNew(1)>
<cfset u = ["cero", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve"]>

<cfset d = ArrayNew(1)>
<cfset d = ["", "", "", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa"]>

<cfset c = ArrayNew(1)>
<cfset c = ["", "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos"]>
	 
<cffunction name="numberToLetters">

	<cfargument name="vNumber" type="string">
	
		<cfset t = "">
		<cfset m = listToArray(reverse(vNumber),"")>
	 
		<cfloop index="i" from="1" to="#ArrayLen(m)#" step="3">
			
			<cfset x = t>
		    <!--- formamos un n?mero de 2 d?gitos 
				 var b=m[i+1]!=undefined?parseFloat(m[i+1].toString()+m[i].toString()):parseFloat(m[i].toString());
			--->
			
			<cfif ArrayIsDefined(m, i+1)>
				<cfset b = LSParseNumber(m[i+1]&m[i])>
			<cfelse>
				<cfset b = LSParseNumber(m[i])>
			</cfif>
			
			
			<!---
				analizamos el 3 d?gito
			    t=m[i+2]!=undefined?(c[m[i+2]]+" "):"";
			--->	   
	   		<cfif ArrayIsDefined(m, i+2)>
				<cfset t = c[m[i+2]+1]>
			<cfelse>
				<cfset t = "">
			</cfif>
	
			<cfset t = t & " ">
	
			<!---
		    t+=b<10?u[b]:(
				b<30?o[b-10]:(
					d[m[i+1]]+(
						m[i]=='0'?"":(
							" y "+u[m[i]]
						)
					)
				)
			);
			--->
			<cfif b lt 10>
				<cfset t = t & u[b+1]>
			<cfelse>
				<cfif b lt 30>	
					<cfset t = t & o[b-10+1]>
				<cfelse>
					<cfset t = t & d[m[i+1]+1]>
				
					<cfif m[i] neq "0">
						<cfset t = t & " y " & u[m[i]+1]>
					</cfif>
					
				</cfif>
			</cfif>

			<cfif t eq "ciento cero">
				<cfset t = "ciento">
			</cfif>
			
			<cfset t = t & " ">
		
			<!---  if (2<i&&i<6)
					  t=t=="uno"?"mil ":(t.replace("uno","un")+" mil ");	
					  --->
			<cfif 2 lt i && i lt 6>

				<cfif t eq "uno">
					<cfset t = "mil">
				<cfelse>
					<cfif t neq " cero ">
						<cfset t = replace(t,"uno","un")&" mil">
					</cfif>
				</cfif>
			</cfif>
			
			<!---
			    if (5<i&&i<9)
			      t=t=="uno"?"un mill?n ":(t.replace("uno","un")+" millones "); --->
			<cfif 5 lt i && i lt 9>
				<cfif t eq "uno">
					<cfset t = "un millon">
				<cfelse>
					<cfif t neq " cero ">
						<cfset t = replace(t,"uno","un")& " millones">
					<cfelse>
						<cfset t = replace(t,"uno","un")& " millones">
					</cfif>
				</cfif>
			</cfif>
		

			<cfif 8 lt i && i lt 12>
				<cfif t eq " uno ">
					<cfset t = "un mil">
				<cfelse>
					<cfif t neq " cero ">
						<cfset t = replace(t,"uno","un")& " mil">
					</cfif>
				</cfif>
			</cfif>

		
			<cfif i eq 7 >
				<cfif t eq " cero ">
					<cfset t = " millones ">
				</cfif>
			</cfif>
		
			<cfset t = t & " ">
		
			<!--- t+=x; --->			
			<cfset t = t & x>

		</cfloop>
	 
		<cfset t = replace(t," cero", "")>		
		<cfset t = trim(t)>
		<cfset t = replace(t," ", "&nbsp;","ALL")>	
	  
		<cfreturn t>				

</cffunction>


<cffunction name="dateToLetters">

	<cfargument name="vDate"		type="date">

	<!--- <cfset vDate = DateFormat(vDate,CLIENT.DateFormatShow)> --->
	
	<cfset sDay = numberToLetters(day(vDate))>	
	<cfset sMonth = Months[Month(vDate)]>
	<cfset sYear  = numberToLetters(Year(vDate))>
	
	<cfset DateLetters = sDay & " de " &sMonth& " de "&sYear>

	<cfreturn trim(DateLetters)>
	
</cffunction>

<cffunction name="DPIToLetters">

	<cfargument name="DPI"		type="string">

	<cfset DPI = replace(DPI," ","","ALL")>
	<cfset DPI = replace(DPI,"-","","ALL")>
	
	<cfif isNumeric(DPI) and len(DPI) EQ 13>
	
		<cfset part1 = DPI.substring(0,4)>
		<cfset letters1 = numberToLetters(part1)>
		
		<cfset cero = listToArray(part1,"")>
		<cfloop index="i" from="1" to="#ArrayLen(cero)#" step="1">
			<cfif cero[i] eq "0">
				<cfset letters1 = "cero "&letters1>
			<cfelse>
				<cfbreak>
			</cfif>
		</cfloop>
	
		<cfset part2 = DPI.substring(4,9)>
		<cfset letters2 = numberToLetters(part2)>
		
		<cfset cero = listToArray(part2,"")>
		<cfloop index="i" from="1" to="#ArrayLen(cero)#" step="1">
			<cfif cero[i] eq "0">
				<cfset letters2 = "cero "&letters2>
			<cfelse>
				<cfbreak>
			</cfif>
		</cfloop>
		
		<cfset part3 = DPI.substring(9)>
		<cfset letters3 = numberToLetters(part3)>
		
		<cfset cero = listToArray(part3,"")>
		<cfloop index="i" from="1" to="#ArrayLen(cero)#" step="1">
			<cfif cero[i] eq "0">
				<cfset letters3 = "cero "&letters3>
			<cfelse>
				<cfbreak>
			</cfif>
		</cfloop>
		
		<cfset DPILetters = letters1 & ", "& letters2 & ", "& letters3>
		
		<cfset DPILetters = Replace(DPILetters,"  , ",", ","all")>
		<cfset DPILetters = Replace(DPILetters," , ",", ","all")>
	
		<cfreturn DPILetters>
	
	<cfelse>
		<cfreturn "[#DPI# no es un DPI v&aacute;lido]">
	</cfif>
	
</cffunction>

<cffunction name="PassportToLetters">

	<cfargument name="Passport"		type="string">

	<cfset Passport = replace(Passport," ","","ALL")>
	<cfset Passport = replace(Passport,".","","ALL")>
	
	<cfset passportList = listToArray(Passport,"")>
	
	<cfset passportResult = "">
	<cfset token = "">
	<cfset priorToken = "">
	<cfset actualToken = "">
	
	<cfloop index="i" from="1" to="#ArrayLen(passportList)#" step="1">
	
		<cfset step = passportList[i]>
	
		<cfif isNumeric(step)>
			<cfset actualToken = "numbers">
		<cfelse>
			<cfset actualToken = "letters">
		</cfif>
	
		<!-- first character --->
		<cfif priorToken eq "">
		
			<cfset token = step>
		
		<cfelse>
		
			<cfif actualToken eq priorToken>
				<cfset token = token & step>
			<cfelse>
			
				<cfif priorToken eq "letters">
					<cfset passportResult = passportResult & " "& token>
				<cfelseif priorToken eq "numbers">
				 
				   	<cfset cero = listToArray(token,"")>
					<cfloop index="i" from="1" to="#ArrayLen(cero)#" step="1">
						<cfif cero[i] eq "0">
							<cfset passportResult = passportResult & " cero ">
							<cfset token = mid(token,2,len(token))>
						<cfelse>
							<cfbreak>
						</cfif>
					</cfloop>
				
					<cfset passportResult = passportResult & " " &numberToLetters(token)>
				</cfif>
			
				<!--- re-initialize token --->
				<cfset token = step>
			
			</cfif>
		
		</cfif>
	
		<cfset priorToken = actualToken>
	
	</cfloop>		
	
	<cfif actualToken eq "letters">
		<cfset passportResult = passportResult & " " &token>
	<cfelseif actualToken eq "numbers">
		<cfset cero = listToArray(token,"")>
		<cfloop index="i" from="1" to="#ArrayLen(cero)#" step="1">
			<cfif cero[i] eq "0">
				<cfset passportResult = passportResult & " cero ">
				<cfset token = mid(token,2,len(token))>
			<cfelse>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfset passportResult = passportResult & " " &numberToLetters(token)>
	</cfif>
	
	<cfset passportResult = replace(passportResult,"-"," gui&oacute;n ","ALL")>
	
	<cfreturn passportResult>
	
</cffunction>
