﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ТипЗнч(Запись.Классификация) = Тип("СправочникСсылка.ЗональныеКоэффициентыНалогНаИмущество") Тогда 
		Оповестить("ИзмененЗональныйКоэффициент");
	ИначеЕсли ТипЗнч(Запись.Классификация) = Тип("СправочникСсылка.ОтраслевыеКоэффициентыНалогНаИмущество") Тогда
		Оповестить("ИзмененОтраслевойКоэффициент");
	ИначеЕсли ТипЗнч(Запись.Классификация) = Тип("СправочникСсылка.РегиональныеКоэффициентыНалогНаИмущество") Тогда
		Оповестить("ИзмененРегиональныйКоэффициент");
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

