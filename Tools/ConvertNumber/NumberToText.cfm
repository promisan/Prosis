<cfparam name="Attributes.Amount"   		Default="0.00">
<cfparam name="Attributes.Lang"     		Default="ENG">
<cfparam name="Attributes.Currency" 		Default="">
<cfparam name="Attributes.ShowCurrency"		Default="1">
<cfparam name="Attributes.ShowCents" 		Default="1">

<cfif IsNumeric(Attributes.Amount)>

	<cfif ListFind("ENG,ESP",Ucase(Attributes.Lang)) eq "0">
		<cfset Attributes.Lang = "ENG">
	</cfif>

	<cfset EngOnes     = "one,two,three,four,five,six,seven,eight,nine"> 
	<cfset EngOnesExc  = "|,|,|,|,|,|,|,|,|">
	
	<cfset EngTeens    = "ten,eleven,twelve,thirteen,fourteen,fifteen,sixteen,seventeen,eighteen,nineteen"> 
	<cfset EngTens     = "dummy,twenty,thirty,forty,fifty,sixty,seventy,eighty,ninety"> 
	<cfset EngHundreds = "one hundred,two hundred,three hundred,four hundred,five hundred,six hundred,seven hundred,eight hundred,nine hundred">
	<cfset EngSuffix   = "thousand,million,billion,trillion">
	<cfset EngHundred  = "hundred">
	<cfset EngHundredSingular = "one hundred">
	<cfset ENGUnitAdd  = "">
	<cfset ENGCentsAdd = " and ">

	<cfset ESPOnes     = "un,dos,tres,cuatro,cinco,seis,siete,ocho,nueve">
	<cfset ESPOnesExc  = "uno,|,|,|,|,|,|,|,|">
	 
	<cfset ESPTeens    = "diez,once,doce,trece,catorce,quince,dieciseis,diecisiete,dieciocho,diecinueve"> 
	<cfset ESPTens     = "dummy,veinte,treinta,cuarenta,cincuenta,sesenta,setenta,ochenta,noventa"> 
	<cfset ESPHundreds = "ciento, doscientos, trescientos, cuatrocientos, quinientos, seiscientos, setecientos, ochocientos, novecientos">
	<cfset ESPSuffix   = "mil,millon,billon,trillon">
	<cfset ESPHundred  = "cientos">
	<cfset ESPHundredSingular = "cien">
	<cfset ESPUnitAdd  = "y ">
	<cfset ESPCentsAdd = " con ">

	<cfoutput>

		<cfset InInteger = INT(abs(val(Attributes.Amount)))>
		<cfset SuffixNum = #INT((Len(InInteger)-"0.5")/3)#+1>		<!--- get number of groups of three from input --->
		<!--- <cfset Cents = Right("0" & ((#Attributes.Amount#-#InInteger#)*100),2)> --->
		<cfset Cents = REReplaceNoCase("#numberFormat(Attributes.Amount,'.__')#", "[0-9]+.", "")>
		<cfset TextNumber = "">

		<cfset FullNumber = InInteger>

		<!--- loop over groups of three numbers starting from the right, extract the string eq of the number and tack on the suffix --->
		<cfloop index="cnt" from="1" to="#SuffixNum#">

			<cfif Len(FullNumber) lt "3" OR INT(Right(FullNumber,3)) neq "0">

				<cfset TensJoiner  = Evaluate(Attributes.Lang & "UnitAdd")>
				
				<cfset OnesList    = Evaluate(Attributes.Lang & "Ones")>
				<cfset OnesListExc = Evaluate(Attributes.Lang & "OnesExc")>
				<cfset TeensList   = Evaluate(Attributes.Lang & "Teens")>
				<cfset TensList    = Evaluate(Attributes.Lang & "Tens")>
				<cfset HundredList = Evaluate(Attributes.Lang & "Hundreds")>
				<cfset HundredSing = Evaluate(Attributes.Lang & "HundredSingular")>	
				
				<cfif Len(FullNumber) gt "1">									<!--- double digit --->	
					<cfset CurNum  = Right(FullNumber,2)>
					<cfset LeftNum = Left(CurNum,1)>
				<cfelse>	
					<cfset CurNum  = Right(FullNumber,1)>						<!--- else get singleDigit --->
					<cfset LeftNum = "0">
				</cfif>	
				
				<cfset SuffixText = "">											<!--- initially blank as Hundreds do not have a suffix --->
				<cfif cnt neq 1>												<!--- if Thousands and above, get suffix --->
					<cfset SuffixList = Evaluate(Attributes.Lang & "Suffix")>
					<cfset SuffixText = " " & #ListGetAt(SuffixList,cnt-1)# & " "> 
				</cfif>
			
				<cfif CurNum lt "20">											<!--- if single or teens (10 <= x < 20) --->
					<cfif LeftNum eq "0">
						<cfif Right(CurNum,1) neq "0">
							
							<cfset OnesException = ListGetAt(OnesListExc,Right(CurNum,1)) >
							
							<cfif OnesException neq "|" AND Trim(Attributes.ShowCurrency) neq "1" AND TextNumber eq "">
								<cfset vOnes = OnesException>
							<cfelse>
								<cfset vOnes = ListGetAt(OnesList,Right(CurNum,1))>	
							</cfif>		
							
							<cfset TextNumber = #vOnes# & #SuffixText# & #TextNumber#>
							
						<cfelse>
							<cfset TextNumber = #SuffixText# & #TextNumber#>
						</cfif>	
					<cfelse>	
						<cfset TextNumber = #ListGetAt(TeensList,Right(CurNum,1)+1)# & #SuffixText# & #TextNumber#>
					</cfif>
				<cfelse>														<!--- get tens --->
					<cfif Right(CurNum,1) neq "0">	
						<cfset OnesException = ListGetAt(OnesListExc,Right(CurNum,1)) >
						
						<cfif OnesException neq "|" AND Trim(Attributes.ShowCurrency) neq "1">
							<cfset vOnes = OnesException>
						<cfelse>
							<cfset vOnes = ListGetAt(OnesList,Right(CurNum,1))>	
						</cfif>		
							 
						<cfset TextNumber = #ListGetAt(TensList,Left(CurNum,1))# & " " & #TensJoiner# & #vOnes# & #SuffixText# & #TextNumber#>
					<cfelse>	
						<cfset TextNumber = #ListGetAt(TensList,Left(CurNum,1))# & #SuffixText# & #TextNumber#>
					</cfif>	
				</cfif>	
				
				<cfif Len(FullNumber) gt 2>												<!--- add hundreds amounts --->
					<cfset CurNum = #Right(FullNumber,3)#>
					<cfif Left(CurNum,1) neq "0">
						<cfif CurNum eq "100">											<!--- special case for exactly one hundred --->
							<cfset TextNumber = #HundredSing# & " " & #TextNumber#>	
						<cfelse>	
							<cfset TextNumber = #ListGetAt(HundredList,Left(CurNum,1))# & " " & #TextNumber#>			
						</cfif>	
					</cfif>
				</cfif>

			</cfif>

			<cfset FullNumber = INT(FullNumber/1000)>

		</cfloop>

	</cfoutput>

	<cfset vTextAmount = "#TextNumber#">	

	<cfif Attributes.ShowCurrency eq "1">
		<cfset vTextAmount = "#vTextAmount# #Attributes.Currency#">	
	</cfif>	

	<cfif Attributes.ShowCents eq "1">
		<cfset Joiner = Evaluate(Attributes.Lang & "CentsAdd")>
		<cfset vTextAmount = "#vTextAmount# #Joiner# #Cents#/100">	
	</cfif>

	<cfset vTextAmount = Replace(vTextAmount,"  "," ","ALL")>
	<cfset caller.TextAmount = vTextAmount>
	
<cfelse>

	<cfset caller.TextAmount ="## Input Conversion Error ##">

</cfif>

