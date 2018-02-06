﻿
#Область СлужебныйПрограммныйИнтерфейс

// Обработчик двойного щелчка мыши, нажатия клавиши Enter или гиперссылки в табличном документе формы отчета.
// См. "Расширение поля формы для поля табличного документа.Выбор" в синтакс-помощнике.
//
// Параметры:
//   ФормаОтчета          - УправляемаяФорма - Форма отчета.
//   Элемент              - ПолеФормы        - Табличный документ.
//   Область              - ОбластьЯчеекТабличногоДокумента - Выбранное значение.
//   СтандартнаяОбработка - Булево - Признак выполнения стандартной обработки события.
//
Процедура ОбработкаВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя = "Отчет.РезультатыПроверкиУчета" Тогда
		Расшифровка = Область.Расшифровка;
		Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
			СтандартнаяОбработка = Ложь;
			ИсправитьПроблему(ФормаОтчета, Расшифровка);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура открывающая форму для интерактивный действий пользователя
// для решения проблемы.
//
// Параметры:
//   Форма                          - УправляемаяФорма - Форма отчета.
//   Расшифровка - Структура - Структура, содержащая данные по исправлению проблемы
//                 расшифровки ячейки отчета по результатам проверок учета.
//      * ИдентификаторПроверки          - Строка - Строковый индикатор проверки.
//      * ОбработчикПереходаКИсправлению - Строка - Имя функции-обработчика исправления проблемы.
//                                         Под функцией-обработчиком понимать экспортную процедуру
//                                         клиентского общего модуля. Либо полное имя открываемой формы.
//      * ВидПроверки                    - СправочникСсылка.ВидыПроверок - Ссылка на вид проверок.
//
Процедура ИсправитьПроблему(Форма, Расшифровка)
	
	ОбработчикПереходаКИсправлению = Расшифровка.ОбработчикПереходаКИсправлению;
	ИдентификаторПроверки          = Расшифровка.ИдентификаторПроверки;
	ВидПроверки                    = Расшифровка.ВидПроверки;
	
	Если СтрНачинаетсяС(ОбработчикПереходаКИсправлению, "ОбщаяФорма.") Или СтрНайти(ОбработчикПереходаКИсправлению, ".Форма") > 0 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ИдентификаторПроверки", ИдентификаторПроверки);
		ПараметрыФормы.Вставить("ВидПроверки",           ВидПроверки);
		
		ОткрытьФорму(ОбработчикПереходаКИсправлению, ПараметрыФормы, Форма);
		
	Иначе
		
		ОбработчикИсправления = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОбработчикПереходаКИсправлению, ".");
		ИсполняемыйФрагмент = ОбработчикИсправления[0] + "." + ОбработчикИсправления[1] + "(ИдентификаторПроверки, ВидПроверки)";
		Результат = Вычислить(ИсполняемыйФрагмент);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти