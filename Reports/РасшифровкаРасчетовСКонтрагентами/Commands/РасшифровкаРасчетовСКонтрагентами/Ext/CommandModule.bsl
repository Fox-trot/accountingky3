﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Вариант = Новый Структура;
	Вариант.Вставить("ИмяОтчета",    "РасшифровкаРасчетовСКонтрагентами");
	Вариант.Вставить("КлючВарианта", "РасшифровкаРасчетовСКонтрагентами");
	
	БухгалтерскиеОтчетыКлиент.ОткрытьВариантОтчета(Вариант);
	
КонецПроцедуры

#КонецОбласти
