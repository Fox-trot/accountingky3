﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Вариант = Новый Структура;
	Вариант.Вставить("ИмяОтчета"   , "АнализНеоплаченныхСчетовПокупателям");
	Вариант.Вставить("КлючВарианта", "НеоплаченныеСчетаПокупателям");
	
	БухгалтерскиеОтчетыКлиент.ОткрытьВариантОтчета(Вариант);
	
КонецПроцедуры

#КонецОбласти
