﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыАдминистрирования, ЗапрашиватьПараметрыАдминистрированияИБ;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ОповещатьОЗакрытии", ОповещатьОЗакрытии);
	
	НомерСеансаИнформационнойБазы = НомерСеансаИнформационнойБазы();
	УсловноеОформление.Элементы[0].Отбор.Элементы[0].ПравоеЗначение = НомерСеансаИнформационнойБазы;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		СеансЗапущенБезРазделителей = МодульРаботаВМоделиСервиса.СеансЗапущенБезРазделителей();
	Иначе
		СеансЗапущенБезРазделителей = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая()
		Или Не ((Не СеансЗапущенБезРазделителей И Пользователи.ЭтоПолноправныйПользователь())
		Или Пользователи.ЭтоПолноправныйПользователь(, Истина)) Тогда
		
		Элементы.ЗавершитьСеанс.Видимость = Ложь;
		Элементы.ЗавершитьСеансКонтекст.Видимость = Ложь;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Элементы.СписокПользователейРазделениеДанных.Видимость = Ложь;
	КонецЕсли;
	
	ИмяКолонкиСортировки = "НачалоРаботы";
	НаправлениеСортировки = "Возр";
	
	ЗаполнитьСписокВыбораФильтраСоединений();
	Если Параметры.Свойство("ОтборИмяПриложения") Тогда
		Если Элементы.ОтборИмяПриложения.СписокВыбора.НайтиПоЗначению(Параметры.ОтборИмяПриложения) <> Неопределено Тогда
			ОтборИмяПриложения = Параметры.ОтборИмяПриложения;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьСписокПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗапрашиватьПараметрыАдминистрированияИБ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	Если ОповещатьОЗакрытии Тогда
		ОповещатьОЗакрытии = Ложь;
		ОповеститьОВыборе(Неопределено);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборИмяПриложенияПриИзменении(Элемент)
	ЗаполнитьСписок();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокПользователей

&НаКлиенте
Процедура СписокПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьПользователяИзСписка();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьСеанс(Команда)
	
	КоличествоВыделенныхСтрок = Элементы.СписокПользователей.ВыделенныеСтроки.Количество();
	
	Если КоличествоВыделенныхСтрок = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Не выбраны пользователи для завершения сеансов.'"));
		Возврат;
	ИначеЕсли КоличествоВыделенныхСтрок = 1 Тогда
		Если Элементы.СписокПользователей.ТекущиеДанные.Сеанс = НомерСеансаИнформационнойБазы Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Невозможно завершить текущий сеанс. Для выхода из программы можно закрыть главное окно программы.'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	НомераСеансов = Новый Массив;
	Для Каждого ИдентификаторСтроки Из Элементы.СписокПользователей.ВыделенныеСтроки Цикл
		НомерСеанса = СписокПользователей.НайтиПоИдентификатору(ИдентификаторСтроки).Сеанс;
		Если НомерСеанса = НомерСеансаИнформационнойБазы Тогда
			Продолжить;
		КонецЕсли;
		НомераСеансов.Добавить(НомерСеанса);
	КонецЦикла;
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.РазделениеВключено И ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		
		СтандартнаяОбработка = Истина;
		ОповещениеПослеЗавершенияСеансов = Новый ОписаниеОповещения(
			"ПослеЗавершенияСеанса", ЭтотОбъект, Новый Структура("НомераСеансов", НомераСеансов));
		ИнтеграцияСТехнологиейСервисаКлиент.ПриЗавершенииСеансов(ЭтотОбъект, НомераСеансов, СтандартнаяОбработка, ОповещениеПослеЗавершенияСеансов);
		
	Иначе
		Если ЗапрашиватьПараметрыАдминистрированияИБ Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьСеансПродолжение", ЭтотОбъект, НомераСеансов);
			ЗаголовокФормы = НСтр("ru = 'Завершение сеанса'");
			ПоясняющаяНадпись = НСтр("ru = 'Для завершения сеанса необходимо ввести параметры
				|администрирования кластера серверов'");
			СоединенияИБКлиент.ПоказатьПараметрыАдминистрирования(ОписаниеОповещения, Ложь, Истина, ПараметрыАдминистрирования, ЗаголовокФормы, ПоясняющаяНадпись);
		Иначе
			ЗавершитьСеансПродолжение(ПараметрыАдминистрирования, НомераСеансов);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыполнить()
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналРегистрации()
	
	ВыделенныеСтроки = Элементы.СписокПользователей.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Выберите пользователей для просмотра журнала регистрации.'"));
		Возврат;
	КонецЕсли;
	
	ОтборПоПользователям = Новый СписокЗначений;
	Для Каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
		СтрокаПользователя = СписокПользователей.НайтиПоИдентификатору(ИдентификаторСтроки);
		ИмяПользователя = СтрокаПользователя.ИмяПользователя;
		Если ОтборПоПользователям.НайтиПоЗначению(ИмяПользователя) = Неопределено Тогда
			ОтборПоПользователям.Добавить(СтрокаПользователя.ИмяПользователя, СтрокаПользователя.ИмяПользователя);
		КонецЕсли;
	КонецЦикла;
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("Пользователь", ОтборПоПользователям));
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию()
	
	СортировкаПоКолонке("Возр");
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию()
	
	СортировкаПоКолонке("Убыв");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПользователя(Команда)
	ОткрытьПользователяИзСписка();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПользователей.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокПользователей.Сеанс");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,, Истина));

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписок()
	
	// Для восстановления позиции запомним текущий сеанс.
	ТекущийСеанс = Неопределено;
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущийСеанс = ТекущиеДанные.Сеанс;
	КонецЕсли;
	
	ЗаполнитьСписокПользователей();
	
	// Восстанавливаем текущую строку по сохраненному сеансу.
	Если ТекущийСеанс <> Неопределено Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Сеанс", ТекущийСеанс);
		НайденныеСеансы = СписокПользователей.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСеансы.Количество() = 1 Тогда
			Элементы.СписокПользователей.ТекущаяСтрока = НайденныеСеансы[0].ПолучитьИдентификатор();
			Элементы.СписокПользователей.ВыделенныеСтроки.Очистить();
			Элементы.СписокПользователей.ВыделенныеСтроки.Добавить(Элементы.СписокПользователей.ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПоКолонке(Направление)
	
	Колонка = Элементы.СписокПользователей.ТекущийЭлемент;
	Если Колонка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКолонкиСортировки = Колонка.Имя;
	НаправлениеСортировки = Направление;
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораФильтраСоединений()
	ИменаПриложений = Новый Массив;
	ИменаПриложений.Добавить("1CV8");
	ИменаПриложений.Добавить("1CV8C");
	ИменаПриложений.Добавить("WebClient");
	ИменаПриложений.Добавить("Designer");
	ИменаПриложений.Добавить("COMConnection");
	ИменаПриложений.Добавить("WSConnection");
	ИменаПриложений.Добавить("BackgroundJob");
	ИменаПриложений.Добавить("SystemBackgroundJob");
	ИменаПриложений.Добавить("SrvrConsole");
	ИменаПриложений.Добавить("COMConsole");
	ИменаПриложений.Добавить("JobScheduler");
	ИменаПриложений.Добавить("Debugger");
	ИменаПриложений.Добавить("OpenIDProvider");
	ИменаПриложений.Добавить("RAS");
	
	СписокВыбора = Элементы.ОтборИмяПриложения.СписокВыбора;
	Для Каждого ИмяПриложения Из ИменаПриложений Цикл
		СписокВыбора.Добавить(ИмяПриложения, ПредставлениеПриложения(ИмяПриложения));
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователей()
	
	СписокПользователей.Очистить();
	
	Если НЕ ОбщегоНазначения.РазделениеВключено()
	 ИЛИ ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Пользователи.НайтиНеоднозначныхПользователейИБ(Неопределено);
	КонецЕсли;
	
	СеансыИнформационнойБазы = ПолучитьСеансыИнформационнойБазы();
	КоличествоАктивныхПользователей = СеансыИнформационнойБазы.Количество();
	
	ФильтроватьИменаПриложений = ЗначениеЗаполнено(ОтборИмяПриложения);
	Если ФильтроватьИменаПриложений Тогда
		ИменаПриложений = СтрРазделить(ОтборИмяПриложения, ",");
	КонецЕсли;
	
	Для Каждого СеансИБ Из СеансыИнформационнойБазы Цикл
		Если ФильтроватьИменаПриложений
			И ИменаПриложений.Найти(СеансИБ.ИмяПриложения) = Неопределено Тогда
			КоличествоАктивныхПользователей = КоличествоАктивныхПользователей - 1;
			Продолжить;
		КонецЕсли;
		
		СтрПользователя = СписокПользователей.Добавить();
		
		СтрПользователя.Приложение   = ПредставлениеПриложения(СеансИБ.ИмяПриложения);
		СтрПользователя.НачалоРаботы = СеансИБ.НачалоСеанса;
		СтрПользователя.Компьютер    = СеансИБ.ИмяКомпьютера;
		СтрПользователя.Сеанс        = СеансИБ.НомерСеанса;
		СтрПользователя.Соединение   = СеансИБ.НомерСоединения;
		
		Если ТипЗнч(СеансИБ.Пользователь) = Тип("ПользовательИнформационнойБазы")
		   И ЗначениеЗаполнено(СеансИБ.Пользователь.Имя) Тогда
			
			СтрПользователя.Пользователь        = СеансИБ.Пользователь.Имя;
			СтрПользователя.ИмяПользователя     = СеансИБ.Пользователь.Имя;
			СтрПользователя.ПользовательСсылка  = НайтиСсылкуПоИдентификаторуПользователя(
				СеансИБ.Пользователь.УникальныйИдентификатор);
			
			Если ОбщегоНазначения.РазделениеВключено() 
				И Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
				
				СтрПользователя.РазделениеДанных = ЗначенияРазделителейДанныхВСтроку(
					СеансИБ.Пользователь.РазделениеДанных);
			КонецЕсли;
			
		ИначеЕсли ОбщегоНазначения.РазделениеВключено()
		        И Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
			
			СтрПользователя.Пользователь       = Пользователи.ПолноеИмяНеуказанногоПользователя();
			СтрПользователя.ИмяПользователя    = "";
			СтрПользователя.ПользовательСсылка = Неопределено;
		Иначе
			СвойстваНеУказанного = ПользователиСлужебный.СвойстваНеуказанногоПользователя();
			СтрПользователя.Пользователь       = СвойстваНеУказанного.ПолноеИмя;
			СтрПользователя.ИмяПользователя    = "";
			СтрПользователя.ПользовательСсылка = СвойстваНеУказанного.Ссылка;
		КонецЕсли;

		Если СеансИБ.НомерСеанса = НомерСеансаИнформационнойБазы Тогда
			СтрПользователя.НомерРисункаПользователя = 0;
		Иначе
			СтрПользователя.НомерРисункаПользователя = 1;
		КонецЕсли;
		
	КонецЦикла;
	
	СписокПользователей.Сортировать(ИмяКолонкиСортировки + " " + НаправлениеСортировки);
	
КонецПроцедуры

&НаСервере
Функция ЗначенияРазделителейДанныхВСтроку(РазделениеДанных)
	
	Результат = "";
	Значение = "";
	Если РазделениеДанных.Свойство("ОбластьДанных", Значение) Тогда
		Результат = Строка(Значение);
	КонецЕсли;
	
	ЕстьДругиеРазделители = Ложь;
	Для каждого Разделитель Из РазделениеДанных Цикл
		Если Разделитель.Ключ = "ОбластьДанных" Тогда
			Продолжить;
		КонецЕсли;
		Если Не ЕстьДругиеРазделители Тогда
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + " ";
			КонецЕсли;
			Результат = Результат + "(";
		КонецЕсли;
		Результат = Результат + Строка(Разделитель.Значение);
		ЕстьДругиеРазделители = Истина;
	КонецЦикла;
	Если ЕстьДругиеРазделители Тогда
		Результат = Результат + ")";
	КонецЕсли;
	Возврат Результат;
		
КонецФункции

&НаСервере
Функция НайтиСсылкуПоИдентификаторуПользователя(Идентификатор)
	
	// Нет доступа к разделенному справочнику из неразделенного сеанса.
	Если ОбщегоНазначения.РазделениеВключено() 
		И Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ШаблонТекстаЗапроса = "ВЫБРАТЬ
					|	Ссылка КАК Ссылка
					|ИЗ
					|	%1
					|ГДЕ
					|	ИдентификаторПользователяИБ = &Идентификатор";
					
	ТекстЗапросаПоПользователям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаЗапроса, Метаданные.Справочники.Пользователи.ПолноеИмя());
	
	ТекстЗапросаПоВнешнимПользователям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаЗапроса, Метаданные.Справочники.ВнешниеПользователи.ПолноеИмя());
	
	Запрос.Текст = ТекстЗапросаПоПользователям;
	Запрос.Параметры.Вставить("Идентификатор", Идентификатор);
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапросаПоВнешнимПользователям;
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции

&НаКлиенте
Процедура ОткрытьПользователяИзСписка()
	
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Пользователь = ТекущиеДанные.ПользовательСсылка;
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ПараметрыОткрытия = Новый Структура("Ключ", Пользователь);
		Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
			ОткрытьФорму("Справочник.Пользователи.Форма.ФормаЭлемента", ПараметрыОткрытия);
		ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
			ОткрытьФорму("Справочник.ВнешниеПользователи.Форма.ФормаЭлемента", ПараметрыОткрытия);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьСеансПродолжение(Результат, МассивСеансов) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыАдминистрирования = Результат;
	
	СтруктураСеанса = Новый Структура;
	СтруктураСеанса.Вставить("Свойство", "Номер");
	СтруктураСеанса.Вставить("ВидСравнения", ВидСравнения.ВСписке);
	СтруктураСеанса.Вставить("Значение", МассивСеансов);
	Фильтр = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтруктураСеанса);
	
	Попытка
		УдалитьСеансыИнформационнойБазыНаСервере(ПараметрыАдминистрирования, Фильтр)
	Исключение
		ЗапрашиватьПараметрыАдминистрированияИБ = Истина;
		ВызватьИсключение;
	КонецПопытки;
	
	ЗапрашиватьПараметрыАдминистрированияИБ = Ложь;
	
	ПослеЗавершенияСеанса(КодВозвратаДиалога.ОК, Новый Структура("НомераСеансов", МассивСеансов));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияСеанса(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Если ДополнительныеПараметры.НомераСеансов.Количество() > 1 Тогда
			
			ТекстОповещения = НСтр("ru = 'Сеансы %1 завершены.'");
			НомераСеансов = СтрСоединить(ДополнительныеПараметры.НомераСеансов, ",");
			ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОповещения, НомераСеансов);
			ПоказатьОповещениеПользователя(НСтр("ru = 'Завершение сеансов'"),, ТекстОповещения);
			
		Иначе
			
			ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сеанс %1 завершен.'"), ДополнительныеПараметры.НомераСеансов[0]);
			ПоказатьОповещениеПользователя(НСтр("ru = 'Завершение сеанса'"),, ТекстОповещения);
			
		КонецЕсли;
		
		ЗаполнитьСписок();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСеансыИнформационнойБазыНаСервере(ПараметрыАдминистрирования, Фильтр)
	
	АдминистрированиеКластера.УдалитьСеансыИнформационнойБазы(ПараметрыАдминистрирования,, Фильтр);
	
КонецПроцедуры

#КонецОбласти
