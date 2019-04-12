﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);

	Возврат Результат;

КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат "Контроль отрицательных остатков" + БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	СтруктураСчетов = СтруктураСчетов();
	
	Для Каждого Счета Из СтруктураСчетов Цикл
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, Счета.Ключ, Счета.Значение);
		
	КонецЦикла;
	
	УсловноеОформлениеАвтоотступа = Неопределено;
	Для каждого ЭлементОформления Из КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = "Уменьшенный автоотступ" Тогда
			УсловноеОформлениеАвтоотступа = ЭлементОформления;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа = Неопределено Тогда
		УсловноеОформлениеАвтоотступа = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		УсловноеОформлениеАвтоотступа.Представление = "Уменьшенный автоотступ";
		УсловноеОформлениеАвтоотступа.Оформление.УстановитьЗначениеПараметра("Автоотступ", 1);
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
		УсловноеОформлениеАвтоотступа.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		УсловноеОформлениеАвтоотступа.Поля.Элементы.Очистить();
	КонецЕсли;
		
	// Дополнительные данные
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя           = "НачОстаток";
	Колонка.Использование = Истина;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, Новый ПолеКомпоновкиДанных("НачОстаток"));
	
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя           = "Расход";
	Колонка.Использование = Истина;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, Новый ПолеКомпоновкиДанных("Расход"));
	
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя           = "КонОстаток";
	Колонка.Использование = Истина;
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Колонка.Выбор, Новый ПолеКомпоновкиДанных("КонОстаток"));
	
	Структура = Таблица.Строки.Добавить();
	
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить();
			
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
			
		КонецЕсли;
	КонецЦикла;
	
	Структура = Структура.Структура.Добавить();
	
	ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Номенклатура");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
	
	ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Использование  = Истина;
	ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Счет");
	ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
	
	Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	
	Если УсловноеОформлениеАвтоотступа.Поля.Элементы.Количество() = 0 Тогда
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, Результат);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

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
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Описание = НСтр("ru = 'Контроль отрицательных остатков.'");
КонецПроцедуры

Функция СтруктураСчетов()

	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХозрасчетныйВидыСубконто.Ссылка КАК Счет,
	|	ХозрасчетныйВидыСубконто.ВидСубконто
	|ПОМЕСТИТЬ ВидыСубконтоНоменклатура
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|ГДЕ
	|	ХозрасчетныйВидыСубконто.ВидСубконто = &ВидСубконтоНоменклатура
	|	И ХозрасчетныйВидыСубконто.Ссылка.Количественный
	|	И НЕ ХозрасчетныйВидыСубконто.ТолькоОбороты
	|	И НЕ ХозрасчетныйВидыСубконто.Ссылка.ЗапретитьИспользоватьВПроводках
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозрасчетныйВидыСубконто.Ссылка КАК Счет,
	|	ХозрасчетныйВидыСубконто.ВидСубконто
	|ПОМЕСТИТЬ ВидыСубконтоСклады
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ХозрасчетныйВидыСубконто
	|ГДЕ
	|	ХозрасчетныйВидыСубконто.ВидСубконто = &ВидСубконтоСклады
	|	И ХозрасчетныйВидыСубконто.Ссылка.Количественный
	|	И НЕ ХозрасчетныйВидыСубконто.ТолькоОбороты
	|	И НЕ ХозрасчетныйВидыСубконто.Ссылка.ЗапретитьИспользоватьВПроводках
	|	И ХозрасчетныйВидыСубконто.Ссылка В
	|			(ВЫБРАТЬ
	|				ВидыСубконтоНоменклатура.Счет КАК Счет
	|			ИЗ
	|				ВидыСубконтоНоменклатура КАК ВидыСубконтоНоменклатура)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыСубконтоСклады.Счет КАК Счет
	|ИЗ
	|	ВидыСубконтоСклады КАК ВидыСубконтоСклады
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В
	|			(ВЫБРАТЬ
	|				ВидыСубконтоНоменклатура.Счет КАК Счет
	|			ИЗ
	|				ВидыСубконтоНоменклатура КАК ВидыСубконтоНоменклатура)
	|	И НЕ Хозрасчетный.Ссылка В
	|				(ВЫБРАТЬ
	|					ВидыСубконтоСклады.Счет КАК Счет
	|				ИЗ
	|					ВидыСубконтоСклады КАК ВидыСубконтоСклады)";
	
	Запрос.УстановитьПараметр("ВидСубконтоСклады", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	Запрос.УстановитьПараметр("ВидСубконтоНоменклатура",ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	
	Результат = Запрос.ВыполнитьПакет();
	
	СтруктураСчетов = Новый Структура;
	
	СтруктураСчетов.Вставить("СчетаУчетаСкладИНоменклатура", Результат[2].Выгрузить().ВыгрузитьКолонку("Счет"));
	СтруктураСчетов.Вставить("СчетаУчетаНоменклатураБезСклада", Результат[3].Выгрузить().ВыгрузитьКолонку("Счет"));
	
	Возврат СтруктураСчетов;
	
КонецФункции

#КонецОбласти

#КонецЕсли