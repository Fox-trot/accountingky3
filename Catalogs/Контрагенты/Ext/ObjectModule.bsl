﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью.
//
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		Если СтранаРезидентства = Справочники.СтраныМира.Киргизия Тогда
			ПризнакСтраны = Перечисления.ПризнакиСтраны.КР;
		ИначеЕсли СтранаРезидентства.УчастникЕАЭС Тогда 
			ПризнакСтраны = Перечисления.ПризнакиСтраны.ЕАЭС;
		Иначе 
			ПризнакСтраны = Перечисления.ПризнакиСтраны.ИмпортЭкспорт;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ПриЗаписи.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Создание договора.
	Если НЕ ЭтоГруппа Тогда
		НадоСоздатьДоговор = Истина;
		ДоговорСсылка = Неопределено;

		Если НЕ ЭтоНовый() Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ДоговорыКонтрагентов.Ссылка КАК Договор
				|ИЗ
				|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
				|ГДЕ
				|	ДоговорыКонтрагентов.Владелец = &Владелец
				|	И НЕ ДоговорыКонтрагентов.ПометкаУдаления
				|
				|УПОРЯДОЧИТЬ ПО
				|	ДоговорыКонтрагентов.НомерДоговора УБЫВ";
			Запрос.УстановитьПараметр("Владелец", Ссылка);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			Если Не РезультатЗапроса.Пустой() Тогда
				Выборка = РезультатЗапроса.Выбрать();
				Выборка.Следующий();
				ДоговорСсылка = Выборка.Договор;
				
				НадоСоздатьДоговор = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Если НадоСоздатьДоговор Тогда
			// Создадим договор контрагента.
			ДоговорОбъект = Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
			ДоговорОбъект.Заполнить(Ссылка);
			ДоговорСсылка = Справочники.ДоговорыКонтрагентов.ПолучитьСсылку();
			ДоговорОбъект.УстановитьСсылкуНового(ДоговорСсылка);
			БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(ДоговорОбъект);
		КонецЕсли;
		
		// Установка основного договора.
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ОсновныеДоговорыКонтрагента.Договор КАК Договор
			|ИЗ
			|	РегистрСведений.ОсновныеДоговорыКонтрагента КАК ОсновныеДоговорыКонтрагента
			|ГДЕ
			|	ОсновныеДоговорыКонтрагента.Организация = &Организация
			|	И ОсновныеДоговорыКонтрагента.Контрагент = &Контрагент";
		Запрос.УстановитьПараметр("Контрагент", Ссылка);
		Запрос.УстановитьПараметр("Организация", БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация"));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой()
			И ЗначениеЗаполнено(ДоговорСсылка) Тогда 
			Справочники.ДоговорыКонтрагентов.УстановитьОсновнойДоговорКонтрагента(ДоговорСсылка);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти
	
#КонецЕсли