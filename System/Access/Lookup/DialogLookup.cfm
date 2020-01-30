
<cfoutput>

<cfset root = "#SESSION.root#">

<script>

var root = "#root#";

function SearchPerson(formname, fieldname) {
	    window.open(root + "/DWarehouse/Search/IndexSearch.cfm?FormName=" + formname + "&FieldName=" + fieldname, "SearchPerson", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}

function selectvendor(FormName, fldvendor, fldvendorname) {
	    window.open(root + "/Procurement/Vendor/VendorSearch.cfm?FormName=" + FormName + "&fldvendor= " + fldvendor + "&fldvendorname= " + fldvendorname, "IndexWindow", "width=600, height=550, toolbar=no, scrollbars=yes, resizable=yes");
}

function selectitem(FormName, flditem, flditemname, fldacc, fldaccdes, fldacctpe) {
	    window.open(root + "/Warehouse/Item/ItemSearchAccount.cfm?FormName=" + FormName + "&flditem= " + flditem + "&flditemname= " + flditemname + "&fldacc= " + fldacc + "&fldaccdes= " + fldaccdes + "&fldacctpe= " + fldacctpe, "IndexWindow", "width=700, height=600, toolbar=no, scrollbars=yes, resizable=yes");
}

function selectaccount(hform, acc, des, tpe) {
 	window.open(root + "/Gledger/Ledger/Inquiry/AccountSelect.cfm?ID=" + hform + "&ID1=" + acc + "&ID2=" + des + "&ID3=" + tpe, "AccountSelect", "left=100, top=100, width=500, height=650, toolbar=no, status=yes, scrollbars=yes, resizable=no");
}

function selectbank(hform, bnk, acc, cur) {
  	window.open(root + "/Gledger/Reference/Bank/BankSelect.cfm?ID=" + hform + "&ID1=" + bnk + "&ID2=" + acc +"&ID9=" + cur, "BankSelect", "left=100, top=100, width=400, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>

</cfoutput>