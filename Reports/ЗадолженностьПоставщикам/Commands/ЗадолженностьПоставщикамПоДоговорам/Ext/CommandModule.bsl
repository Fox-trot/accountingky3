﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Вариант = Новый Структура;
	Вариант.Вставить("ИмяОтчета",    "ЗадолженностьПоставщикам");
	Вариант.Вставить("КлючВарианта", "ЗадолженностьПоставщикамПоДоговорам");
	
	БухгалтерскиеОтчетыКлиент.ОткрытьВариантОтчета(Вариант);
	
КонецПроцедуры

#КонецОбласти
