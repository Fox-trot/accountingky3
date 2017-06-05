﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = КонецГода(ТекущаяДата());
		Если ЕстьДокументВУказанныйПериод(Дата) Тогда
			Дата = Дата('00010101');
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

// В обработчике события ОбработкаПроверкиЗаполнения документа выполняется
// копирование и обнуление проверяемых реквизитов для исключения стандартной
// проверки заполнения платформой и последующей проверки средствами встроенного языка.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);	
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
КонецПроцедуры

Функция ЕстьДокументВУказанныйПериод(Дата)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтчетПоНалогуНаИмущество.Ссылка
		|ИЗ
		|	Документ.ОтчетПоНалогуНаИмущество КАК ОтчетПоНалогуНаИмущество
		|ГДЕ
		|	НЕ ОтчетПоНалогуНаИмущество.ПометкаУдаления
		|	И КОНЕЦПЕРИОДА(ОтчетПоНалогуНаИмущество.Дата, ГОД) = &Дата";
	
	Запрос.УстановитьПараметр("Дата", Дата);		
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Количество() > 0 	

КонецФункции

#КонецОбласти

#КонецЕсли