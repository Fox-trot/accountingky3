﻿
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	Если НЕ Параметры.Отказ И КаталогРасширенийВызовСервера.КаталогРасширенийИспользуется() Тогда
		Форма = ПолучитьФорму("Обработка.КаталогРасширений.Форма.ФормаУведомлений");
		Форма.ПриОткрытииФормы(); 
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуВерсииРасширения(Знач ИдентификаторВерсии, Знач Наименование, Знач ВладелецФормы = Неопределено) Экспорт 
	
	ПараметрыНовойФормы = Новый Структура;
	ПараметрыНовойФормы.Вставить("ИдентификаторВерсии", ИдентификаторВерсии);
	ПараметрыНовойФормы.Вставить("НаименованиеРасширения", Наименование);
	
	ОткрытьФорму("Обработка.КаталогРасширений.Форма.ФормаОбъектаРасширение", 
		ПараметрыНовойФормы, 
		ВладелецФормы,,,,, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти