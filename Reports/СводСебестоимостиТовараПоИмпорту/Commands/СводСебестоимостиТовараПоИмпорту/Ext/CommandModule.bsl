﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Вариант = Новый Структура;
	Вариант.Вставить("ИмяОтчета",    "СводСебестоимостиТовараПоИмпорту");
	Вариант.Вставить("КлючВарианта", "СводСебестоимостиТовараПоИмпорту");
	
	БухгалтерскиеОтчетыКлиент.ОткрытьВариантОтчета(Вариант);
	
КонецПроцедуры

#КонецОбласти