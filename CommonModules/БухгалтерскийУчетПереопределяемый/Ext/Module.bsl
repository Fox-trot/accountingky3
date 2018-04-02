﻿
// Функция возвращает Истина, если в конфигурации ведется учет по валютам.
//
Функция ИспользоватьВалютныйУчет() Экспорт

	Возврат Истина;

КонецФункции // ИспользоватьВалютныйУчет()

// Снимает/устанавливает активность проводок документа (бух. учет).
//
Процедура ПереключитьАктивностьПроводокБУ(Документ) Экспорт
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "ПометкаУдаления") Тогда
		Возврат;
	КонецЕсли;

	ПроводкиДокумента = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	ПроводкиДокумента.Отбор.Регистратор.Установить(Документ);
	ПроводкиДокумента.Прочитать();

	КоличествоПроводок = ПроводкиДокумента.Количество();
	Если НЕ (КоличествоПроводок = 0) Тогда
		
		// Определяем текущую активность проводок по первой проводке
		ТекущаяАктивностьПроводок = ПроводкиДокумента[0].Активность;

		// Инвертируем текущую активность проводок
		ПроводкиДокумента.УстановитьАктивность(НЕ ТекущаяАктивностьПроводок);
		ПроводкиДокумента.Записать();

	КонецЕсли;
		
КонецПроцедуры // ПереключитьАктивностьПроводокБУ()

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПОЛУЧЕНИЯ НАСТРОЕК ПОЛЬЗОВАТЕЛЕЙ

// Функция возвращает значение по умолчанию для передаваемого пользователя и настройки.
//
// Параметры:
//  Настройка         - Строка - вид настройки, значение по умолчанию которой необходимо получить
//  ИмяПользователяИБ - Строка - имя пользователя ИБ программы, настройка которого
//				   запрашивается, если параметр не передается настройка возвращается для текущего пользователя
//
// Возвращаемое значение:
//  Значение по умолчанию для настройки.
//
Функция ПолучитьЗначениеПоУмолчанию(Настройка, ИмяПользователяИБ = Неопределено) Экспорт

	НастройкаВРег = ВРег(Настройка);
	НастройкаТипаСсылка = Ложь;
	
	Если НастройкаВРег = ВРег("ОсновнаяОрганизация") Тогда
		Возврат Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	Если НастройкаВРег = ВРег("УчетнаяЗаписьЭлектроннойПочты") Тогда
		ПустоеЗначение = Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка();
		ИмяОбъекта = "Справочник.УчетныеЗаписиЭлектроннойПочты";
		НастройкаТипаСсылка = Истина;
	ИначеЕсли НастройкаВРег = ВРег("Подпись") Тогда
		ПустоеЗначение = НоваяПодпись();
		Возврат Неопределено;
	КонецЕсли;
	
	ЗначениеНастройки = ХранилищеОбщихНастроек.Загрузить(НастройкаВРег,,, ИмяПользователяИБ);
	
	Если ТипЗнч(ЗначениеНастройки) = ТипЗнч(ПустоеЗначение) Тогда
		Если НастройкаТипаСсылка Тогда
			Если НЕ ОбщегоНазначения.СсылкаСуществует(ЗначениеНастройки) Тогда
				ЗначениеНастройки = ПустоеЗначение;
			Иначе
				Запроc = Новый Запрос;
				Запроc.УстановитьПараметр("Ссылка", ЗначениеНастройки);
				Запроc.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
				|	ЗначенияОбъекта.Ссылка
				|ИЗ
				|	" + ИмяОбъекта + " КАК ЗначенияОбъекта
				|ГДЕ
				|	ЗначенияОбъекта.Ссылка = &Ссылка";
				Результат = Запроc.Выполнить();
				Если Результат.Пустой() Тогда
					ЗначениеНастройки = ПустоеЗначение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ЗначениеНастройки = ПустоеЗначение;
	КонецЕсли;
	
	Возврат ?(ЗначениеНастройки = Неопределено, ПустоеЗначение, ЗначениеНастройки);
	
КонецФункции // ПолучитьЗначениеПоУмолчанию()

///////////////////////////////////////////////////////////////////////////////
// ПОЛУЧЕНИЕ ПЕРСОНАЛЬНЫХ НАСТРОЕК ЭЛЕКТРОННОЙ ПОЧТЫ

Функция НоваяПодпись()
	
	Подпись = НСтр("ru='С уважением%1'");
	АвторизованныйПользователь = Пользователи.АвторизованныйПользователь();
	ДанныеПользователя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(АвторизованныйПользователь, "Наименование, Служебный");
	Если ДанныеПользователя.Служебный Тогда
		ПредставлениеПользователя = ".";
		
	Иначе
		ПредставлениеПользователя = ", " + ДанныеПользователя.Наименование + ".";
		
	КонецЕсли;
	
	Подпись = СтрШаблон(Подпись, ПредставлениеПользователя);
	
	Возврат Подпись;
	
КонецФункции

