﻿// Параметры формы:
//     Уровень                           - Число - Запрашиваемый уровень.
//     Родитель                          - УникальныйИдентификатор - Родительский объект.
//     СкрыватьНеактуальныеАдреса        - Булево - флаг того, что при неактуальные адреса будут скрываться.
//     ФорматАдреса - Строка - вариант классификатора.
//     Идентификатор                     - УникальныйИдентификатор - Текущий адресный элемент.
//     Представление                     - Строка - Представление текущего элемента,. используется если не указан
//                                                  Идентификатор.
//
// Результат выбора:
//     Структура - с полями
//         * Отказ                      - Булево - флаг того, что при обработке произошла ошибка.
//         * КраткоеПредставлениеОшибки - Строка - Описание ошибки.
//         * Идентификатор              - УникальныйИдентификатор - Данные адреса.
//         * Представление              - Строка                  - Данные адреса.
//         * РегионЗагружен             - Булево                  - Имеет смысл только для регионов, Истина, если есть
//                                                                  записи.
// ---------------------------------------------------------------------------------------------------------------------
//
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Родитель", Родитель);
	Параметры.Свойство("Уровень",  Уровень);
	
	Параметры.Свойство("ТипАдреса", ТипАдреса);
	Параметры.Свойство("СкрыватьНеактуальные", СкрыватьНеактуальные);
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("КоличествоЗаписей", 3000);
	
	Если НЕ ЗначениеЗаполнено(Родитель) И Уровень > 1 Тогда
		// поиск адреса без родителя 
		КраткоеПредставлениеОшибки = НСтр("ru = 'Поле не содержит адресных сведений для выбора.'");
		Возврат;
	КонецЕсли;
	
	ДанныеКлассификатора = Обработки.РасширенныйВводКонтактнойИнформации.АдресаДляИнтерактивногоВыбора(Родитель, Уровень, ТипАдреса, ПараметрыПоиска);
	
	Если ДанныеКлассификатора.Отказ Тогда
		// Сервис на обслуживании
		КраткоеПредставлениеОшибки = НСтр("ru = 'Автоподбор и проверка адреса недоступны:'") + Символы.ПС + ДанныеКлассификатора.КраткоеПредставлениеОшибки;
		Возврат;
		
	ИначеЕсли ДанныеКлассификатора.Данные.Количество() = 0 Тогда
		КраткоеПредставлениеОшибки = НСтр("ru = 'Поле не содержит адресных сведений для выбора.'");
		// Нет данных, функционал выбора не применим.
	КонецЕсли;
	
	ВариантыАдреса.Загрузить(ДанныеКлассификатора.Данные);
	Заголовок = ДанныеКлассификатора.Заголовок;
	
	// Текущая строка
	ТекущееЗначение = Неопределено;
	Кандидаты       = Неопределено;
	
	Параметры.Свойство("Идентификатор", ТекущееЗначение);
	Если ЗначениеЗаполнено(ТекущееЗначение) Тогда
		Кандидаты = ВариантыАдреса.НайтиСтроки( Новый Структура("Идентификатор", ТекущееЗначение));
	Иначе
		Параметры.Свойство("Представление", ТекущееЗначение);
		Если ЗначениеЗаполнено(ТекущееЗначение) Тогда
			Кандидаты = ВариантыАдреса.НайтиСтроки( Новый Структура("Представление", ТекущееЗначение));
		КонецЕсли;
	КонецЕсли;
	
	Если Кандидаты <> Неопределено И Кандидаты.Количество() > 0 Тогда
		Элементы.ВариантыАдреса.ТекущаяСтрока = Кандидаты[0].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(КраткоеПредставлениеОшибки) Тогда
		ОповеститьВладельца(Неопределено, Истина);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантыАдресаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ПроизвестиВыбор(Значение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроизвестиВыбор(Знач НомерСтроки)
	
	Данные = ВариантыАдреса.НайтиПоИдентификатору(НомерСтроки);
	Если Данные = Неопределено Тогда
		Возврат;
		
	ИначеЕсли Не Данные.Неактуален Тогда
		ОповеститьВладельца(Данные);
		Возврат;
		
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроизвестиВыборЗавершениеВопроса", ЭтотОбъект, Данные);
	
	ПредупреждениеНеактуальности = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Адрес ""%1"" неактуален.
		           |Продолжить?'"), Данные.Представление);
		
	ЗаголовокПредупреждения = НСтр("ru = 'Подтверждение'");
	
	ПоказатьВопрос(Оповещение, ПредупреждениеНеактуальности, РежимДиалогаВопрос.ДаНет, , ,ЗаголовокПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиВыборЗавершениеВопроса(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОповеститьВладельца(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьВладельца(Знач Данные, Отказ = Ложь)
	
	Результат = РаботаСАдресамиКлиентСервер.КонструкторРезультатаВыбора();
	
	Если Данные <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, Данные);
	Иначе
		Результат.Отказ = Истина;
	КонецЕсли;
	
	ОповеститьОВыборе(Результат);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыАдресаПредставление.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыАдреса.Неактуален");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиОчистка(Элемент, СтандартнаяОбработка)
	Элементы.ВариантыАдреса.ОтборСтрок = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура НайтиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ДлинаТекста = СтрДлина(Текст);
		Фильтр = Новый ФиксированнаяСтруктура("Представление", Текст);
		Элементы.ВариантыАдреса.ОтборСтрок = Фильтр;
	Иначе
		Элементы.ВариантыАдреса.ОтборСтрок = Неопределено;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
