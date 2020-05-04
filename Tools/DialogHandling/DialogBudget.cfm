
<cfoutput>
<cfset root = "#SESSION.root#">

	<script>
	
	var root = "#root#";
	
	function CarryProgram(Period, ParentUnit, ProgramCode){
		    ptoken.open(root + "/ProgramREM/Application/Program/CarryOver/ProgramCarryOver.cfm?Period=" + Period + "&ParentUnit=" + ParentUnit, "CarryProgram", "width=700, height=590, toolbar=no, scrollbars=yes, resizable=yes");
	}
	
	function AddComponent(Period, ParentCode, ParentUnit, ProgramCode) {
		    ptoken.open(root + "/ProgramREM/Application/Program/ComponentEntry.cfm?Period=" + Period + "&ParentCode=" + ParentCode + "&ParentUnit=" + ParentUnit + "&EditCode=" + ProgramCode, "AddProgram", "width=850, height=900, toolbar=no, scrollbars=no, resizable=no");
	}
	
	function DeleteProgram(Code,Per) {
		if (confirm("Do you want to deactivate this Program for planning period " + Per + "?")) {
		   ptoken.open(root + "/ProgramREM/Application/Program/ProgramDelete.cfm?ts="+new Date().getTime()+"&ProgramCode=" + Code + "&Period=" + Per, "right");
		}
	}
	
	function ReinstateProgram(Code,Per) {
		if (confirm("Do you want to reinstate this Program for planning period " + Per + "?")) {
		   ptoken.open(root + "/ProgramREM/Application/Program/ProgramReinstate.cfm?ts="+new Date().getTime()+"&ProgramCode=" + Code + "&Period=" + Per, "right");
		}
	}
	
	function EditProgram(Code, Period, Layout) {
	    w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 120;
		_cf_loadingtexthtml='';	
	    ptoken.open(root + "/ProgramREM/Application/Program/ProgramView.cfm?ProgramCode=" + Code + "&Period=" + Period + "&ProgramLayout=" + Layout, "Program", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=yes, scrollbars=yes, resizable=yes");
	}
	
	function ViewProgram(Code, Period, Layout) {
	    w = #CLIENT.width# - 60;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/ProgramREM/Application/Program/ProgramView.cfm?ProgramCode=" + Code + "&Period=" + Period + "&ProgramLayout=" + Layout, "ProgramView", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}
	
	function AllotmentProgram(mission,code,period) {
	    w = #CLIENT.width# - 80;
	    h = #CLIENT.height# - 120;
		ptoken.open(root + "/ProgramREM/Application/Budget/Allotment/AllotmentView.cfm?Mission=" + mission + "&Program=" + code + "&Period=" + period, "ProgramAll", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
	}
	
	function SearchProgram(formname, fieldname) {
		ptoken.open(root + "/Search/IndexSearch.cfm?FormName=" + formname + "&FieldName= " + fieldname, "SearchPerson", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
	}
	
	function LocateProgram(formname, fieldname, last, dob, nat) {
		ptoken.open(root + "/Search/IndexSearchLocate.cfm?ID=" + formname + "&ID1=" + fieldname + "&ID2=" + last + "&ID3=" + dob + "&ID4=" + nat, "SearchPerson", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
	}
	
	function eMail(to,subj) {
		ptoken.open(root + "/Tools/Mail/Mail.cfm?ID=" + to +"&ID1=" + subj, "MailDialog", "width=500, height=480, toolbar=no, scrollbars=no, resizable=no");
	}
	
	function email(to,subj) {
		ptoken.open(root + "/Tools/Mail/Mail.cfm?ID=" + to +"&ID1=" + subj, "MailDialog", "width=1000, height=680, toolbar=no, scrollbars=no, resizable=no");
	}
	
	</script>

</cfoutput>