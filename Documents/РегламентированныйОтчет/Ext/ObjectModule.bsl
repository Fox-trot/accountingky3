﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) Тогда 
		ТекущаяДата = ТекущаяДатаСеанса();
		НачалоПериода = НачалоГода(ТекущаяДата);
		КонецПериода = КонецГода(ТекущаяДата);
		НачалоПредПериода = ДобавитьМесяц(НачалоПериода, -12);
		КонецПредПериода = ДобавитьМесяц(КонецПериода, - 12);
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли