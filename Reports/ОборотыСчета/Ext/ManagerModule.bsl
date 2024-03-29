﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ОборотыСчета");
	НастройкиВарианта.Описание = НСтр("ru = 'Обороты счета'");
КонецПроцедуры

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);

	Возврат Результат;

КонецФункции

// Формирует текст, выводимый в заголовке отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//
// Возвращаемое значение:
//   Строка      - текст заголовка с учетом периода.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Обороты счета %1%2'"),
		ПараметрыОтчета.Счет,
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек,
		"Счет", БухгалтерскийУчетВызовСервераПовтИсп.СчетаВИерархии(ПараметрыОтчета.Счет));
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", ПараметрыОтчета.Периодичность);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ПараметрыОтчета.КонецПериода));
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ПараметрПериод", КонецДня(ТекущаяДатаСеанса()));
	КонецЕсли;
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	
	// Колонка "показатели".
	Если КоличествоПоказателей > 1 Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "Показатели";
		Колонка.Использование = Истина;
		
		ГруппаПоказатели = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	МассивПоказателей = Новый Массив;
	МассивПоказателей.Добавить("БУ");

	МассивПоказателейДоп = Новый Массив;
	МассивПоказателейДоп.Добавить("ВалютнаяСумма");
	МассивПоказателейДоп.Добавить("Количество");
	
	ВидОстатков = ?(ПараметрыОтчета.РазвернутоеСальдо, "Развернутый", "");
	
	ВыводимыеПоля = Новый Массив;
	ПоляОстатков = Новый Массив;
	
	// Колонка "Сальдо на начало Дт".
	Если ПараметрыОтчета.СальдоНаНачалоДт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "НачальноеСальдоДт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатков + "ОстатокДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				ПоляОстатков.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				ПоляОстатков.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Сальдо на начало Кт".
	Если ПараметрыОтчета.СальдоНаНачалоКт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "НачальноеСальдоКт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + ИмяПоказателя + "Начальный" + ВидОстатков + "ОстатокКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				ПоляОстатков.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаНачалоПериода." + ИмяПоказателя + "НачальныйОстатокКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				ПоляОстатков.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Обороты за период Дт".
	Если ПараметрыОтчета.ОборотыЗаПериодДт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "ОборотДт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	УсловноеОформлениеАвтоотступа = Неопределено;
	Для каждого ЭлементОформления Из КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = НСтр("ru = 'Уменьшенный автоотступ'") Тогда
			УсловноеОформлениеАвтоотступа = ЭлементОформления;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа = Неопределено Тогда
		УсловноеОформлениеАвтоотступа = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		УсловноеОформлениеАвтоотступа.Представление = НСтр("ru = 'Уменьшенный автоотступ'");
		УсловноеОформлениеАвтоотступа.Оформление.УстановитьЗначениеПараметра("Автоотступ", 1);
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
		УсловноеОформлениеАвтоотступа.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		УсловноеОформлениеАвтоотступа.Поля.Элементы.Очистить();
	КонецЕсли;
	
	// Колонка "Обороты со счетами Дт".
	Если ПараметрыОтчета.ОборотыСоСчетамиДт Тогда
		Если ПараметрыОтчета.ОборотыЗаПериодДт Тогда 
			Колонка = Колонка.Структура.Добавить();
		Иначе 
			Колонка = Таблица.Колонки.Добавить();
		КонецЕсли;
		Колонка.Имя           = "КорСчетДт";
		Колонка.Использование = Истина;
		
		ПолеГруппировки = Колонка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("КорСчет");
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		
		ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
		ПолеОформления.Поле = ПолеГруппировки.Поле;
		
		Если Не ПараметрыОтчета.ПоСубсчетамКорСчетов Тогда
			ЗначениеОтбора = БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Колонка.Отбор, "SystemFields.LevelInGroup", 1);
			ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Колонка, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
		КонецЕсли;
		
		ЭлементПорядка = Колонка.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЭлементПорядка.Использование     = Истина;
		ЭлементПорядка.Поле              = Новый ПолеКомпоновкиДанных("КорСчет");
		ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Колонка, "РасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, "КорСчет");
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		ОтборГруппаИЛИ = Колонка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ОтборГруппаИЛИ.Применение = ТипПримененияОтбораКомпоновкиДанных.Элементы;
		ОтборГруппаИЛИ.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппаИЛИ, ВыбранноеПоле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппаИЛИ, ВыбранноеПоле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Обороты за период Кт"
	Если ПараметрыОтчета.ОборотыЗаПериодКт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "ОборотКт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Обороты со счетами Кт"
	Если ПараметрыОтчета.ОборотыСоСчетамиКт Тогда
		Если ПараметрыОтчета.ОборотыЗаПериодДт Тогда 
			Колонка = Колонка.Структура.Добавить();
		Иначе 
			Колонка = Таблица.Колонки.Добавить();
		КонецЕсли;
		Колонка.Имя           = "КорСчетКт";
		Колонка.Использование = Истина;
		
		ПолеГруппировки = Колонка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("КорСчет");
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
		
		ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
		ПолеОформления.Поле = ПолеГруппировки.Поле;
		
		Если Не ПараметрыОтчета.ПоСубсчетамКорСчетов Тогда
			ЗначениеОтбора = БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Колонка.Отбор, "SystemFields.LevelInGroup", 1);
			ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Колонка, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
		КонецЕсли;
		
		ЭлементПорядка = Колонка.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ЭлементПорядка.Использование     = Истина;
		ЭлементПорядка.Поле              = Новый ПолеКомпоновкиДанных("КорСчет");
		ЭлементПорядка.ТипУпорядочивания = НаправлениеСортировкиКомпоновкиДанных.Возр;
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Колонка, "РасположениеОбщихИтогов", РасположениеИтоговКомпоновкиДанных.Нет);
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, "КорСчет");
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		ОтборГруппаИЛИ = Колонка.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ОтборГруппаИЛИ.Применение = ТипПримененияОтбораКомпоновкиДанных.Элементы;
		ОтборГруппаИЛИ.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппаИЛИ, ВыбранноеПоле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппаИЛИ, ВыбранноеПоле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Сальдо на конец Дт"
	Если ПараметрыОтчета.СальдоНаКонецДт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "КонечноеСальдоДт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаКонецПериода." + ИмяПоказателя + "Конечный" + ВидОстатков + "ОстатокДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				ПоляОстатков.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокДт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				ПоляОстатков.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Колонка "Сальдо на конец Кт"
	Если ПараметрыОтчета.СальдоНаКонецКт Тогда
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя           = "КонечноеСальдоКт";
		Колонка.Использование = Истина;
		
		Группа = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		Группа.Использование = Истина;
		Группа.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаКонецПериода." + ИмяПоказателя + "Конечный" + ВидОстатков + "ОстатокКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				ПоляОстатков.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
		Для Каждого ИмяПоказателя Из МассивПоказателейДоп Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				ВыбранноеПоле = Новый ПолеКомпоновкиДанных("СальдоНаКонецПериода." + ИмяПоказателя + "КонечныйОстатокКт");
				ВыводимыеПоля.Добавить(ВыбранноеПоле);
				ПоляОстатков.Добавить(ВыбранноеПоле);
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа, ВыбранноеПоле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	ДобавитьОтборПоВыводимымПолям(ВыводимыеПоля, КомпоновщикНастроек.Настройки, Ложь);
	
	Структура = Таблица.Строки.Добавить();
	Структура.Имя = "Счет";
	
	ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Счет");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных")); 
	
	ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
	ПолеОформления.Поле = ПолеГруппировки.Поле;
	
	Если Не ПараметрыОтчета.ПоСубсчетам Тогда
		ЗначениеОтбора = БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(Структура.Отбор, "SystemFields.LevelInGroup", 1);
		ЗначениеОтбора.Применение = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);			
	КонецЕсли;
	
	КоличествоГруппировок = ?(ПараметрыОтчета.ПоСубсчетам, 1, 0);
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить();
			
			Если СтрНайти(ПолеВыбраннойГруппировки.Поле, "КорСубконто1") <> 0
				ИЛИ СтрНайти(ПолеВыбраннойГруппировки.Поле, "КорСубконто2") <> 0
				ИЛИ СтрНайти(ПолеВыбраннойГруппировки.Поле, "КорСубконто3") <> 0 Тогда
				
				ДобавитьУсловноеОформлениеОстатков(Структура, ПоляОстатков);
				
			КонецЕсли;
			
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
			ПолеОформления.Поле = ПолеГруппировки.Поле;
						
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	
	// Период.
	БухгалтерскиеОтчетыВызовСервера.ДобавитьГруппировкуПоПериоду(ПараметрыОтчета, Структура);
	
	Для каждого ЭлементГруппировки Из Структура.ПоляГруппировки.Элементы Цикл
		Если ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных(?(ПараметрыОтчета.Периодичность = 2, "Регистратор", "Период")) Тогда
			Поле = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
			Поле.Поле = ЭлементГруппировки.Поле;
		КонецЕсли;
	КонецЦикла;
	
	// Валюта.
	Если ПараметрыОтчета.ПоказательВалютнаяСумма И БухгалтерскиеОтчетыКлиентСервер.НайтиГруппировку(Таблица.Строки, "Валюта") = Неопределено Тогда
		Структура = Структура.Структура.Добавить();
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Валюта");		
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));	
		
		ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
		ПолеОформления.Поле = ПолеГруппировки.Поле;
				
	КонецЕсли;
	           
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
		
	Если УсловноеОформлениеАвтоотступа.Поля.Элементы.Количество() = 0 Тогда
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// В процедуре можно уточнить особенности вывода данных в отчет.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - описание выводимых данных.
//
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	// Снимем флаг Игнорировать значение Null для реквизитов субконто.
	Для ИндексСубконто = 1 По 3 Цикл
		Для Каждого Поле Из МакетКомпоновки.НаборыДанных.ОстаткиИОборотыПоКорсчетам.Поля Цикл
			
			Если Лев(Поле.ПутьКДанным, 10) = "Субконто" + ИндексСубконто + "." Тогда
				
				Поле.Роль.ИгнорироватьЗначенияNULL = Ложь;
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ЭлементТелаМакета Из МакетКомпоновки.Тело Цикл 
		Если ТипЗнч(ЭлементТелаМакета) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			ПараметрыОтчета.Вставить("ВысотаШапки", МакетКомпоновки.Макеты[ЭлементТелаМакета.МакетШапки].Макет.Количество()); 
			Прервать;	
		КонецЕсли;
	КонецЦикла;
		
	Для Каждого ГруппировкаТелаКомпоновки Из МакетКомпоновки.Тело Цикл
		Если ТипЗнч(ГруппировкаТелаКомпоновки) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
			ПараметрыОтчета.Вставить("ШиринаШапки", МакетКомпоновки.Макеты[ГруппировкаТелаКомпоновки.МакетШапки].Макет[0].Ячейки.Количество()); 
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// В процедуре можно изменить табличный документ после вывода в него данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, Результат);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета, ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
	Результат.ФиксацияСлева = ПараметрыОтчета.ШиринаШапки;
		
КонецПроцедуры

// Задает набор показателей, которые позволяет анализировать отчет.
//
// Возвращаемое значение:
//   Массив      - основные суммовые показатели отчета.
//
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	НаборПоказателей.Добавить("Количество");
	
	Возврат НаборПоказателей;
	
КонецФункции

// Задает набор опций, которые позволяет настраивать отчет.
//
// Возвращаемое значение:
//   Массив      - имена опций.
//
Функция СохраняемыеОпции() Экспорт
	
	КоллекцияНастроек = Новый Массив;
	Для каждого Показатель Из ПолучитьНаборПоказателей() Цикл
		КоллекцияНастроек.Добавить("Показатель" + Показатель);
	КонецЦикла;
	КоллекцияНастроек.Добавить("РазвернутоеСальдо");
	КоллекцияНастроек.Добавить("ПоСубсчетам");
	КоллекцияНастроек.Добавить("ПоСубсчетамКорСчетов");
	КоллекцияНастроек.Добавить("Периодичность");
	КоллекцияНастроек.Добавить("РазмещениеДополнительныхПолей");
	КоллекцияНастроек.Добавить("СальдоНаНачалоДт");
	КоллекцияНастроек.Добавить("СальдоНаНачалоКт");
	КоллекцияНастроек.Добавить("СальдоНаКонецДт");
	КоллекцияНастроек.Добавить("СальдоНаКонецКт");
	КоллекцияНастроек.Добавить("ОборотыЗаПериодДт");
	КоллекцияНастроек.Добавить("ОборотыЗаПериодКт");
	КоллекцияНастроек.Добавить("ОборотыСоСчетамиДт");
	КоллекцияНастроек.Добавить("ОборотыСоСчетамиКт");
	
	Возврат КоллекцияНастроек;
	
КонецФункции

#КонецОбласти

#Область РасшифровкаСтандартныхОтчетов

// Заполняет настройки расшифровки (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки) для переданного
// экземпляра отчета.
//
// Параметры:
//  Настройки				 - Структура								 - Настройки расшифровки отчета, которые нужно заполнить (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//  Объект					 - ОтчетОбъект								 - Отчет из данных которого нудно собрать универсальные настройки.
//  ДанныеРасшифровки		 - ДанныеРасшифровкиКомпоновкиДанных		 - Данные расшифровки отчета.
//  ИдентификаторРасшифровки - ИдентификаторРасшифровкиКомпоновкиДанных  - Идентификатор расшифровки из ячейки для
//                                                                         которой вызвана расшифровка.
//  РеквизитыРасшифровки	 - Структура								 - Реквизиты отчета полученные из контекста расшифровываемой ячейки.
//
Процедура ЗаполнитьНастройкиРасшифровки(Настройки, Объект, ДанныеРасшифровки, ИдентификаторРасшифровки, РеквизитыРасшифровки) Экспорт

	БухгалтерскиеОтчетыРасшифровка.ЗаполнитьНастройкиРасшифровкиПоДаннымСтандартногоОтчета(
		Настройки,
		ДанныеРасшифровки,
		ИдентификаторРасшифровки,
		Объект,
		РеквизитыРасшифровки);
	
	// Отчет может быть расшифрован "Карточкой счета". Дополняем отбором по счету, если расшифровка общего итога.
	ЕстьОтборПоСчету = Ложь;
	ПолеСчет = Новый ПолеКомпоновкиДанных("Счет");
	Для каждого ЭлементОтбора Из Настройки.Отбор.Элементы Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
		   И ЭлементОтбора.Использование
		   И ЭлементОтбора.ЛевоеЗначение = ПолеСчет Тогда // отбор по счету уже есть
			ЕстьОтборПоСчету = Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	Если Не ЕстьОтборПоСчету Тогда // нужен общий отбор по счету
		
		ПрименяемыйВидСравнения = ?(Объект.Счет.ЗапретитьИспользоватьВПроводках,
			ВидСравненияКомпоновкиДанных.ВИерархии, ВидСравненияКомпоновкиДанных.Равно);
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(
			Настройки.Отбор, "Счет", Объект.Счет, ПрименяемыйВидСравнения);
		
	КонецЕсли;
	
КонецПроцедуры

// Адаптирует переданные настройки для данного вида отчетов.
// Перед применением настроек расшифровки может возникнуть необходимость учесть особенности этого вида отчетов.
//
// Параметры:
//  Настройки	 - Структура - Настройки которые нужно адаптировать (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//
Процедура АдаптироватьНастройки(Настройки) Экспорт
	
	ПолеСчет = Новый ПолеКомпоновкиДанных("Счет");
	УдалитьОтбор = Новый Массив;
	
	Для Каждого ЭлементОтбора Из Настройки.Отбор.Элементы Цикл
		
		Если ЭлементОтбора.ЛевоеЗначение = ПолеСчет Тогда
			
			УдалитьОтбор.Добавить(ЭлементОтбора);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ЭлементОтбора Из УдалитьОтбор Цикл
		
		Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает какими отчетами и при каких условиях может быть расшифрован этот вид отчетов.
//
// Параметры:
//  Правила - ТаблицаЗначений - Правила расшифровки этого отчета см. БухгалтерскиеОтчетыРасшифровка.НовыйПравилаРасшифровки.
//
Процедура ЗаполнитьПравилаРасшифровки(Правила) Экспорт

	Правило = Правила.Добавить();
	Правило.Отчет = "ОтчетПоПроводкам";
	БухгалтерскиеОтчетыРасшифровка.ДобавитьТребуемыйРеквизитРасшифровки(Правило.ТребуемыеРеквизиты, "БухТипРесурса", "БухТипРесурса");
	Правило.ШаблонПредставления = НСтр("ru = 'Отчет по проводкам'");
	
	Правило = Правила.Добавить();
	Правило.Отчет = "ОтчетПоПроводкам";
	БухгалтерскиеОтчетыРасшифровка.ДобавитьТребуемыйРеквизитРасшифровки(Правило.ТребуемыеРеквизиты, "БухТипРесурса", "БухТипРесурса", "");
	Правило.Условия.Вставить("БухТипРесурса", "");
	
	Правило.ШаблонПредставления = НСтр("ru = 'Отчет по проводкам'");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОтборПоВыводимымПолям(ВыводимыеПоля, Структура, ВыводитьОтбор = Истина)
	
	// Добавим отбор на пустые строки (Если все выводимые поля для записи равны 0).
	Если ВыводитьОтбор Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Структура, "ВыводитьОтбор", ТипВыводаТекстаКомпоновкиДанных.НеВыводить);
	КонецЕсли;
	
	ОтборГруппировки = Структура.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ОтборГруппировки.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	ОтборГруппировки.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ПропускатьКонтроль = НЕ СтрНайти(ВыводимыеПоля[0], ".Контроль");
	
	Для Каждого ВыбранноеПоле Из ВыводимыеПоля Цикл
		
		Если СтрНайти(ВыбранноеПоле, ".Контроль") И ПропускатьКонтроль Тогда
			Продолжить;
		КонецЕсли;
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборГруппировки, ВыбранноеПоле, 0, ВидСравненияКомпоновкиДанных.НеРавно);
		
	КонецЦикла;
		
КонецПроцедуры

Процедура ДобавитьУсловноеОформлениеОстатков(Настройки, ПоляОстатков)
	
	// Если нет оформляемых полей, то оформление добавлять не нужно.
	Если ПоляОстатков.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	УсловноеОформление = Настройки.УсловноеОформление.Элементы.Добавить();
	Поля = УсловноеОформление.Поля;
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "Текст", "");
	
	Для Каждого Поле Из ПоляОстатков Цикл
		
		ОформляемоеПоле = Поля.Элементы.Добавить();
		ОформляемоеПоле.Поле = Поле;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли