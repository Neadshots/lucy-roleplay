$(document).on('click', '.sign-in-button', function(e) {
	var result = {};
	var skipvariable = 0;
		
	$.each($('.form').serializeArray(), function() {
		   result[this.name] = this.value;
	});
	mta.triggerEvent("sign-in",result['username'], result['password'])
});

$(document).on('click', '.sign-up-button', function(e) {
	var result = {};
	var skipvariable = 0;
		
	$.each($('.form').serializeArray(), function() {
		   result[this.name] = this.value;
	});
	mta.triggerEvent("register",result['username'], result['password'])
});


function logIn(){
	return mta.triggerEvent("onClientStartLogin", $('#Lusername').val(), $('#Lpassword').val());
}

function startRegister(){
	return mta.triggerEvent("onClientStartRegister", $('#Lusername').val(), $('#Lpassword').val());
}

function setChecked(){
	$('#rememberMe').prop('checked', true);
}

function setUsername(txt){
	$('#Lusername').val(txt);
}

function setPassword(txt){
	$('#Lpassword').val(txt);
}

$("#rememberMe").change(function() {
	mta.triggerEvent("onClientChangeLoginCheck", this.checked);
});

function inputChanged(){
	mta.triggerEvent("onClientInputChange");
}