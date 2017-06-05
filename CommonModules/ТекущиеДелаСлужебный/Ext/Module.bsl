﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Текущие дела".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Объявляет служебные события подсистемы ТекущиеДела.
//
// Серверные события:
//   ПриЗаполненииСпискаТекущихДел.
//
// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	// СЕРВЕРНЫЕ СОБЫТИЯ.
	
	// Заполняет список текущих дел пользователя.
	//
	// Параметры:
	//  ТекущиеДела - ТаблицаЗначений - таблица значений с колонками:
	//    * Идентификатор - Строка - внутренний идентификатор дела, используемый механизмом "Текущие дела".
	//    * ЕстьДела      - Булево - если Истина, дело выводится в списке текущих дел пользователя.
	//    * Важное        - Булево - если Истина, дело будет выделено красным цветом.
	//    * Представление - Строка - представление дела, выводимое пользователю.
	//    * Количество    - Число  - количественный показатель дела, выводится в строке заголовка дела.
	//    * Форма         - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
	//                               дела на панели "Текущие дела".
	//    * ПараметрыФормы- Структура - параметры, с которыми нужно открывать форму показателя.
	//    * Владелец      - Строка, объект метаданных - строковый идентификатор дела, которое будет владельцем для текущего
	//                      или объект метаданных подсистема.
	//    * Подсказка     - Строка - текст подсказки.
	//
	// Синтаксис:
	// Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	//
	СерверныеСобытия.Добавить("СтандартныеПодсистемы.ТекущиеДела\ПриЗаполненииСпискаТекущихДел");
	
КонецПроцедуры

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	ИмяМодуля = "ТекущиеДелаСлужебный";
	
	ИмяСобытия = "СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПереименованийОбъектовМетаданных";
	СерверныеОбработчики[ИмяСобытия].Добавить(ИмяМодуля);
	
КонецПроцедуры

// Заполняет список текущих дел пользователя.
//
// Параметры:
//  Параметры       - Структура - пустая структура.
//  АдресРезультата - Строка    - адрес временного хранилища, куда будет помещен
//                                список текущих дел пользователя - ТаблицаЗначений:
//    * Идентификатор - Строка - внутренний идентификатор дела, используемый механизмом "Текущие дела".
//    * ЕстьДела      - Булево - если Истина, дело выводится в списке текущих дел пользователя.
//    * Важное        - Булево - если Истина, дело будет выделено красным цветом.
//    * Представление - Строка - представление дела, выводимое пользователю.
//    * Количество    - Число  - количественный показатель дела, выводится в строке заголовка дела.
//    * Форма         - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                               дела на панели "Текущие дела".
//    * ПараметрыФормы- Структура - параметры, с которыми нужно открывать форму показателя.
//    * Владелец      - Строка, объект метаданных - строковый идентификатор дела, которое будет владельцем для текущего
//                      или объект метаданных подсистема.
//    * Подсказка     - Строка - текст подсказки.
//
Процедура СформироватьСписокТекущихДелПользователя(Параметры, АдресРезультата) Экспорт
	
	ТекущиеДела = НоваяТаблицаТекущихДел();
	
	// Заполнение текущих дел БСП.
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.ТекущиеДела\ПриЗаполненииСпискаТекущихДел");
	
	КоличествоДел       = 0;
	Для Каждого Обработчик Из ОбработчикиСобытия Цикл
		ДобавитьДело(ТекущиеДела, Обработчик.Модуль, КоличествоДел);
	КонецЦикла;
	
	// Добавление дел от прикладных конфигураций.
	ОбработчикиЗаполненияДел = Новый Массив;
	ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел(ОбработчикиЗаполненияДел);
	
	Для Каждого Обработчик Из ОбработчикиЗаполненияДел Цикл
		ДобавитьДело(ТекущиеДела, Обработчик, КоличествоДел);
	КонецЦикла;
	
	// Постобработка результата.
	ПреобразоватьТаблицуТекущихДел(ТекущиеДела);
	
	ПоместитьВоВременноеХранилище(ТекущиеДела, АдресРезультата);
	
КонецПроцедуры

// Возвращает структуру сохраненных настроек отображения дел
// для текущего пользователя.
//
Функция СохраненныеНастройкиОтображения() Экспорт
	
	НастройкиОтображения = ХранилищеОбщихНастроек.Загрузить("ТекущиеДела", "НастройкиОтображения");
	Если НастройкиОтображения = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(НастройкиОтображения) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НастройкиОтображения.Свойство("ДеревоДел")
		И НастройкиОтображения.Свойство("ВидимостьРазделов")
		И НастройкиОтображения.Свойство("ВидимостьДел") Тогда
		Возврат НастройкиОтображения;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов.

// См. одноименную процедуру в общем модуле ПользователиПереопределяемый.
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	// СовместноДляПользователейИВнешнихПользователей.
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ИспользованиеОбработкиТекущиеДела.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет переименования тех объектов метаданных, которые невозможно
//   автоматически найти по типу, но ссылки на которые требуется сохранять
//   в базе данных (например: подсистемы, роли).
//
// См. также:
//   ОбщегоНазначения.ДобавитьПереименование().
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	Библиотека = "СтандартныеПодсистемы";
	
	СтароеИмя = "Роль.ИспользованиеТекущихДел";
	НовоеИмя  = "Роль.ИспользованиеОбработкиТекущиеДела";
	ОбщегоНазначения.ДобавитьПереименование(Итог, "2.3.3.25", СтароеИмя, НовоеИмя, Библиотека);
	
	
КонецПроцедуры

// Получает числовые значения дел из переданного запроса.
//
// Запрос с данными должен содержать только одну строку с произвольным количеством полей.
// Значения этих полей должны являться значениями соответствующих показателей.
//
// Пример простейшего запроса:
//	ВЫБРАТЬ
//		Количество(*) КАК <Имя предопределенного элемента - показателя количества документов>.
//	ИЗ
//		Документ.<Имя документа>.
//
// Параметры:
//  Запрос - выполняемый запрос.
//  ОбщиеПараметрыЗапросов - Структура - общие значения для расчета текущих дел.
//
Функция ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов = Неопределено) Экспорт
	
	// Установим общие параметры для всех запросов.
	// Специфические параметры этого запроса, если таковые имеются, должны быть установлены ранее.
	Если Не ОбщиеПараметрыЗапросов = Неопределено Тогда
		УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов);
	КонецЕсли;
	
	Результат = Запрос.ВыполнитьПакет();
	
	НомераЗапросовПакета = Новый Массив;
	НомераЗапросовПакета.Добавить(Результат.Количество() - 1);
	
	// Выберем все запросы с данными.
	РезультатЗапроса = Новый Структура;
	Для Каждого НомерЗапроса Из НомераЗапросовПакета Цикл
		
		Выборка = Результат[НомерЗапроса].Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			Для Каждого Колонка Из Результат[НомерЗапроса].Колонки Цикл
				ЗначениеДела = ?(ТипЗнч(Выборка[Колонка.Имя]) = Тип("Null"), 0, Выборка[Колонка.Имя]);
				РезультатЗапроса.Вставить(Колонка.Имя, ЗначениеДела);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Возвращает структуру общих значений, используемых для расчета текущих дел.
//
// Возвращаемое значение:
//  Структура - имя значение и само значение.
//
Функция ОбщиеПараметрыЗапросов() Экспорт
	
	ОбщиеПараметрыЗапросов = Новый Структура;
	ОбщиеПараметрыЗапросов.Вставить("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	ОбщиеПараметрыЗапросов.Вставить("ЭтоПолноправныйПользователь", Пользователи.ЭтоПолноправныйПользователь());
	ОбщиеПараметрыЗапросов.Вставить("ТекущаяДата", ТекущаяДатаСеанса());
	ОбщиеПараметрыЗапросов.Вставить("ПустаяДата", '00010101000000');
	
	Возврат ОбщиеПараметрыЗапросов;
	
КонецФункции

// Устанавливает общие параметры запросов для расчета текущих дел.
//
// Параметры:
//  Запрос - выполняемый запрос.
//  ОбщиеПараметрыЗапросов - Структура - общие значения для расчета показателей.
//
Процедура УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов) Экспорт
	
	Для Каждого КлючИЗначение Из ОбщиеПараметрыЗапросов Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	ТекущиеДелаПереопределяемый.УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов);
	
КонецПроцедуры

// Только для внутреннего использования.
//
Процедура УстановитьНачальныйПорядокРазделов(ТекущиеДела) Экспорт
	
	ПорядокРазделовКомандногоИнтерфейса = Новый Массив;
	ТекущиеДелаПереопределяемый.ПриОпределенииПорядкаРазделовКомандногоИнтерфейса(ПорядокРазделовКомандногоИнтерфейса);
	
	Индекс = 0;
	Для Каждого РазделКомандногоИнтерфейса Из ПорядокРазделовКомандногоИнтерфейса Цикл
		Если ТипЗнч(РазделКомандногоИнтерфейса) = Тип("Строка") Тогда
			РазделКомандногоИнтерфейса = СтрЗаменить(РазделКомандногоИнтерфейса, " ", "");
		Иначе
			РазделКомандногоИнтерфейса = СтрЗаменить(РазделКомандногоИнтерфейса.ПолноеИмя(), ".", "");
		КонецЕсли;
		ОтборСтрок = Новый Структура;
		ОтборСтрок.Вставить("ИдентификаторВладельца", РазделКомандногоИнтерфейса);
		
		НайденныеСтроки = ТекущиеДела.НайтиСтроки(ОтборСтрок);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ИндексСтрокиВТаблице = ТекущиеДела.Индекс(НайденнаяСтрока);
			Если ИндексСтрокиВТаблице = Индекс Тогда
				Индекс = Индекс + 1;
				Продолжить;
			КонецЕсли;
			
			ТекущиеДела.Сдвинуть(ИндексСтрокиВТаблице, (Индекс - ИндексСтрокиВТаблице));
			Индекс = Индекс + 1;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
//
Процедура ПреобразоватьТаблицуТекущихДел(ТекущиеДела)
	
	ТекущиеДела.Колонки.Добавить("ИдентификаторВладельца", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(250)));
	ТекущиеДела.Колонки.Добавить("ЭтоРаздел", Новый ОписаниеТипов("Булево"));
	ТекущиеДела.Колонки.Добавить("ПредставлениеРаздела", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(250)));
	
	УдаляемыеДела = Новый Массив;
	Для Каждого Дело Из ТекущиеДела Цикл
		
		Если ТипЗнч(Дело.Владелец) = Тип("ОбъектМетаданных") Тогда
			РазделДоступен = ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Дело.Владелец);
			Если Не РазделДоступен Тогда
				УдаляемыеДела.Добавить(Дело);
				Продолжить;
			КонецЕсли;
			
			Дело.ИдентификаторВладельца = СтрЗаменить(Дело.Владелец.ПолноеИмя(), ".", "");
			Дело.ЭтоРаздел              = Истина;
			Дело.ПредставлениеРаздела   = ?(ЗначениеЗаполнено(Дело.Владелец.Синоним), Дело.Владелец.Синоним, Дело.Владелец.Имя);
		Иначе
			Если ТипЗнч(Дело.Владелец) = Тип("ОбработкаМенеджер.ТекущиеДела") Тогда
				Дело.Владелец = Дело.Владелец.ПолноеИмя();
				Дело.Идентификатор = СтрЗаменить(Дело.Идентификатор, " ", "");
			КонецЕсли;
			
			ЭтоИдентификаторДела = (ТекущиеДела.Найти(Дело.Владелец, "Идентификатор") <> Неопределено);
			Если Не ЭтоИдентификаторДела Тогда
				ЭтоИдентификаторДела = (ТекущиеДела.Найти(СтрЗаменить(Дело.Владелец, " ", ""), "Идентификатор") <> Неопределено);
			КонецЕсли;
			
			Дело.ИдентификаторВладельца = СтрЗаменить(Дело.Владелец, " ", "");
			Если Не ЭтоИдентификаторДела Тогда
				Дело.ЭтоРаздел              = Истина;
				Дело.ПредставлениеРаздела   = Дело.Владелец;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого УдаляемоеДело Из УдаляемыеДела Цикл
		ТекущиеДела.Удалить(УдаляемоеДело);
	КонецЦикла;
	
	ТекущиеДела.Колонки.Удалить("Владелец");
	
КонецПроцедуры

// Создает пустую таблицу дел пользователя.
//
// Возвращаемое значение:
//  ТекущиеДела - ТаблицаЗначений - таблица значений с колонками:
//    * Идентификатор - Строка - внутренний идентификатор дела, используемый механизмом "Текущие дела".
//    * ЕстьДела      - Булево - если Истина, дело выводится в списке текущих дел пользователя.
//    * Важное        - Булево - если Истина, дело будет выделено красным цветом.
//    * Представление - Строка - представление дела, выводимое пользователю.
//    * Количество    - Число  - количественный показатель дела, выводится в строке заголовка дела.
//    * Форма         - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                               дела на панели "Текущие дела".
//    * ПараметрыФормы- Структура - параметры, с которыми нужно открывать форму показателя.
//    * Владелец      - Строка, объект метаданных -
//                               ОбъектМетаданных: Подсистема - подсистема командного интерфейса, в которой
//                                                              будет размещено данное дело.
//                               Строка - идентификатор дела верхнего уровня, требуется
//                                        для указания владельца дочернего дела (расшифровки дела верхнего уровня).
//    * Подсказка     - Строка - текст подсказки.
//
Функция НоваяТаблицаТекущихДел()
	
	ДелаПользователя = Новый ТаблицаЗначений;
	ДелаПользователя.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(250)));
	ДелаПользователя.Колонки.Добавить("ЕстьДела", Новый ОписаниеТипов("Булево"));
	ДелаПользователя.Колонки.Добавить("Важное", Новый ОписаниеТипов("Булево"));
	ДелаПользователя.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(250)));
	ДелаПользователя.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	ДелаПользователя.Колонки.Добавить("Форма", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(250)));
	ДелаПользователя.Колонки.Добавить("ПараметрыФормы", Новый ОписаниеТипов("Структура"));
	ДелаПользователя.Колонки.Добавить("Владелец");
	ДелаПользователя.Колонки.Добавить("Подсказка", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(250)));
	
	Возврат ДелаПользователя;
	
КонецФункции

Процедура ДобавитьДело(ТекущиеДела, Менеджер, КоличествоДел)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительности = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительности");
		НачалоЗамера = МодульОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	Менеджер.ПриЗаполненииСпискаТекущихДел(ТекущиеДела);
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности")
		И ТекущиеДела.Количество() <> КоличествоДел Тогда
		КоличествоДел = ТекущиеДела.Количество();
		ПоследнееДело = ТекущиеДела.Получить(КоличествоДел - 1);
		Владелец = ПоследнееДело.Владелец;
		Если ТипЗнч(Владелец) = Тип("ОбъектМетаданных") Тогда
			ПредставлениеДела = ПоследнееДело.Представление;
		Иначе
			ОписаниеВладельца = ТекущиеДела.Найти(ПоследнееДело.Владелец, "Идентификатор");
			Если ОписаниеВладельца = Неопределено Тогда
				ПредставлениеДела = ПоследнееДело.Представление;
			Иначе
				ПредставлениеДела = ОписаниеВладельца.Представление;
			КонецЕсли;
		КонецЕсли;
		
		КлючеваяОперация = "ОбновлениеТекущихДел." + ПредставлениеДела;
		МодульОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, НачалоЗамера);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
