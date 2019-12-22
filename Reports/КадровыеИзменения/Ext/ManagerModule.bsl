﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	
	Возврат Результат;

КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Кадровые изменения" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

Функция ПолучитьТекстОтбора(Знач ОтборКомпоновкиДанных) Экспорт
	
	ЭлементыОтбора = Новый Массив;
	Для каждого ЭлементОтбора Из ОтборКомпоновкиДанных.Элементы Цикл
		Если НЕ ЭлементОтбора.Использование
			ИЛИ ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Продолжить; // Неиспользуемые отборы и группы отборов не выводим (они могут быть очень громоздкими).
		КонецЕсли;
		Если Строка(ЭлементОтбора.ЛевоеЗначение) = "Организация"
				И ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно
			ИЛИ Строка(ЭлементОтбора.ЛевоеЗначение) = "Дата"
			ИЛИ Строка(ЭлементОтбора.ЛевоеЗначение) = "Тип" Тогда
			Продолжить; // Стандартные отборы не выводим.
		КонецЕсли;
		
		СоставляющиеОтбора = Новый Массив;
		ДоступноеПолеОтбора = ОтборКомпоновкиДанных.ДоступныеПоляОтбора.Элементы.Найти(Строка(ЭлементОтбора.ЛевоеЗначение));
		Если ДоступноеПолеОтбора = Неопределено Тогда
			СоставляющиеОтбора.Добавить(Строка(ЭлементОтбора.ЛевоеЗначение));
		Иначе
			СоставляющиеОтбора.Добавить(ДоступноеПолеОтбора.Заголовок);
		КонецЕсли;
		
		СоставляющиеОтбора.Добавить(Строка(ЭлементОтбора.ВидСравнения));
		СоставляющиеОтбора.Добавить("""" + Строка(ЭлементОтбора.ПравоеЗначение) + """");
		
		ЭлементыОтбора.Добавить(СтрСоединить(СоставляющиеОтбора, " "));
	КонецЦикла;
	
	Возврат СтрСоединить(ЭлементыОтбора, " И ");
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	// Группировка
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировки(ПараметрыОтчета, КомпоновщикНастроек);
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);

	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	Результат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;

	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, Результат);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       см. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет
//   поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КадровыеИзменения");
	НастройкиВарианта.Описание = НСтр("ru = 'Выводит информацию о кадровых изменениях сотрудников за указанный период.'");
КонецПроцедуры

// Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		 Настройки.ОписаниеВариантов.Вставить(Вариант.Имя,Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

Функция ВариантыНастроек() Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("Имя, Представление", "КадровыеИзменения", "Кадровые изменения"));	
	Возврат Массив;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("Организация", Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей", 0);
	КоллекцияНастроек.Вставить("Группировка", Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля", Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок", Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал", Ложь);
	КоллекцияНастроек.Вставить("МакетОформления", Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных", Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("ПериодОтчета"         	, Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        	, Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         	, Дата(1,1,1));
	ПараметрыОтчета.Вставить("Подразделение"        	, Неопределено);
	ПараметрыОтчета.Вставить("Сотрудник"         		, Неопределено);
	ПараметрыОтчета.Вставить("РежимРасшифровки"     	, Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    	, Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"	, Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  	, "");
	ПараметрыОтчета.Вставить("ДобавлятьДетальныеЗаписи"  , Ложь);
	
	Возврат ПараметрыОтчета;
	
КонецФункции

#КонецОбласти

#КонецЕсли
