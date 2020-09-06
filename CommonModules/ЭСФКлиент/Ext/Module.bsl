﻿
#Область ПрограммныйИнтерфейс

// Обработчик нажатия на гиперссылку ЭСФ в форме документа.
//
// Параметры:
//  ПредставлениеЭСФ - Строка, ДокументСсылка.ЭлектронныйСчетФактураВыписанный - Представление ЭСФ, нажатие на который нужно обработать
//  ЭтаФорма		 - УправляемаяФорма - Форма, в которой нужно обработать открытие
//
Процедура ПредставлениеЭСФНажатие(ПредставлениеЭСФ, ЭтаФорма) Экспорт
	
	Если ТипЗнч(ПредставлениеЭСФ) = Тип("Строка")
		И ПредставлениеЭСФ = "Создать новый ЭСФ (выписанный)" Тогда
		// Создать новый ЭСФ.
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Основание", ЭтаФорма.Объект.Ссылка);
		ОткрытьФорму("Документ.ЭлектронныйСчетФактураВыписанный.ФормаОбъекта", СтруктураПараметров, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ТипЗнч(ПредставлениеЭСФ) = Тип("Строка")
		И ПредставлениеЭСФ = "Создать новый ЭСФ (полученный)" Тогда
		// Создать новый ЭСФ.
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Основание", ЭтаФорма.Объект.Ссылка);
		ОткрытьФорму("Документ.ЭлектронныйСчетФактураПолученный.ФормаОбъекта", СтруктураПараметров, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ТипЗнч(ПредставлениеЭСФ) = Тип("ДокументСсылка.ЭлектронныйСчетФактураВыписанный") Тогда 
		ПоказатьЗначение(, ПредставлениеЭСФ);
	ИначеЕсли ТипЗнч(ПредставлениеЭСФ) = Тип("ДокументСсылка.ЭлектронныйСчетФактураПолученный") Тогда 
		ПоказатьЗначение(, ПредставлениеЭСФ);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

