﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.ВидыОплатОрганизаций);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	ИспользуютсяПодарочныеСертификаты = ПолучитьфункциональнуюОпцию("ИспользуютсяПодарочныеСертификаты");
	
	Элементы.Контрагент.Видимость = ПравоДоступа("Просмотр", Метаданные.Справочники.Контрагенты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Группа Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Родитель", Родитель);
	
	Если Копирование Тогда
		
		Если Элемент.ТекущиеДанные.ТипОплаты = ПредопределенноеЗначение("Перечисление.ТипыОплат.Наличные") Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
	Для каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
		
		Если НЕ ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			ЗначенияЗаполнения.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение);
		КонецЕсли;
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			ЗначенияЗаполнения.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение[0].Значение);
		КонецЕсли;
	
	КонецЦикла;
	
	ТипОплатыДоступныеЗначения = ПолучитьДоступныеЗначенияТипаОплаты();
	Если ТипОплатыДоступныеЗначения.Количество() > 0 Тогда
		ПараметрыФормы.Вставить("ТипОплатыДоступныеЗначения", ТипОплатыДоступныеЗначения)
	КонецЕсли;
	
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.ВидыОплатОрганизаций.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущаяСтрока);
	
	Если НЕ Элемент.ТекущиеДанные.ТипОплаты = ПредопределенноеЗначение("Перечисление.ТипыОплат.Наличные") Тогда
	
		ТипОплатыДоступныеЗначения = ПолучитьДоступныеЗначенияТипаОплаты();
		Если ТипОплатыДоступныеЗначения.Количество() > 0 Тогда
			ПараметрыФормы.Вставить("ТипОплатыДоступныеЗначения", ТипОплатыДоступныеЗначения)
		КонецЕсли;
		
		ОткрытьФорму("Справочник.ВидыОплатОрганизаций.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	ОбщегоНазначенияБПСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьДоступныеЗначенияТипаОплаты()

	ТипОплатыДоступныеЗначения = Новый Массив;
	
	Для каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
	
		Если НЕ ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если Строка(ЭлементОтбора.ЛевоеЗначение) <> "ТипОплаты" Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
			ТипОплатыДоступныеЗначения.Добавить(ЭлементОтбора.ПравоеЗначение);
		КонецЕсли;
		
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			Для каждого ЭлементСпискаЗначений Из ЭлементОтбора.ПравоеЗначение Цикл
				ТипОплатыДоступныеЗначения.Добавить(ЭлементСпискаЗначений.Значение);
			КонецЦикла;
		КонецЕсли;

	КонецЦикла;
	
	Если ТипОплатыДоступныеЗначения.Количество() = 0 Тогда
		
		ТипОплатыДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипыОплат.ПлатежнаяКарта"));
		ТипОплатыДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипыОплат.БанковскийКредит"));
		
		Если ИспользуютсяПодарочныеСертификаты Тогда
			ТипОплатыДоступныеЗначения.Добавить(ПредопределенноеЗначение("Перечисление.ТипыОплат.ПодарочныйСертификатСобственный"));
		КонецЕсли;
		
	КонецЕсли;

	Возврат ТипОплатыДоступныеЗначения;

КонецФункции

&НаСервере
Процедура СброситьПользовательскиеОтборы(Список, Настройки)
	
	Для каждого ЭлементНастроек Из Настройки.Элементы Цикл
		Если ТипЗнч(ЭлементНастроек) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЭлементНастроек.Использование = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти