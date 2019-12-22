﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
// В программе наименование основной спецификации, если она всего одна, по умолчанию совпадает с наименованием продукции.
// Если спецификации уже задано наименование - не такое, как у продукции - то оно изменено не будет.
//
// Параметры:
//  ОсновнаяСпецификацияНоменклатуры - СправочникСсылка.СпецификацииНоменклатуры - контролируемая спецификация
//  Номенклатура					 - СправочникСсылка.Номенклатура - владелец спецификации
//  Наименование					 - Строка - новое наименование продукции
//  ПараметрыЗаписи					 - Структура - может содержать ключ НаименованиеДоИзменения (наименование продукции)
//
Процедура ИсправитьНаименованиеСпецификации(Спецификация, Номенклатура, Наименование, ПараметрыЗаписи) Экспорт
	
	Если Не ЗначениеЗаполнено(Спецификация) Тогда
		Возврат;
	КонецЕсли;
	
	Если НесколькоСпецификацийНоменклатуры(Номенклатура) Тогда
		Возврат;
	КонецЕсли;
	
	НаименованиеСпецификации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Спецификация, "Наименование");
	
	Если НаименованиеСпецификации = Наименование Тогда
		Возврат;
	КонецЕсли;
	
	НаименованиеДоИзменения = "";
	ПараметрыЗаписи.Свойство("НаименованиеДоИзменения", НаименованиеДоИзменения);
	
	Если Не ПустаяСтрока(НаименованиеДоИзменения) 
		И Не ПустаяСтрока(НаименованиеСпецификации)
		И НаименованиеСпецификации <> НаименованиеДоИзменения Тогда
		// Пользователь задал спецификации особое наименование. Сохраним его
		Возврат;
	КонецЕсли;
	
	ОбъектОсновнаяСпецификация = Спецификация.ПолучитьОбъект();
	ОбъектОсновнаяСпецификация.Наименование = Наименование;
	ОбъектОсновнаяСпецификация.Записать();
	
КонецПроцедуры

// Функция - Циклы спецификаций
//
// Параметры:
//  СтрутураОтбора			 - Структура - 
//  МаксимальнаяДлинаПути	 - Число	 - Максимальная длина пути, который будем контролировать
// 
// Возвращаемое значение:
//  Таблица - значений вида
//  - Предок, Потомок, Спецификация
//
Функция ЦиклыСпецификаций(СтрутураОтбора = Неопределено, МаксимальнаяДлинаПути = 10) Экспорт

	// Определение циклов основано на следующей идее:
	// Будем считать уровнем элемента количество прямо или косвенно «предшествующих» ему других элементов (в смысле
	// конкретного отношения). Такой уровень на основе таблицы транзитивного замыкания легко посчитать для ориентированного
	// графа любого вида. Нетрудно догадаться, что уровень всех элементов, находящихся в цикле, будет одинаков.
	// Тогда признаком того, что дуга принадлежит циклу, будет одинаковый уровень ее концов.

	// В результате получаем следующий запрос, находящий дуги, принадлежащие циклу.
     Запрос = Новый Запрос;

	Если СтрутураОтбора = Неопределено Тогда 
		// Проверка всех спецификаций.
		Пролог = "ВЫБРАТЬ Выход.Владелец НачалоДуги, Вход.Номенклатура КонецДуги, Выход.Ссылка ПОМЕСТИТЬ ИсходноеОтношение
	            | ИЗ Справочник.СпецификацииНоменклатуры КАК Выход
	            | СОЕДИНЕНИЕ Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК Вход ПО Выход.Ссылка = Вход.Ссылка;
	            | ВЫБРАТЬ РАЗЛИЧНЫЕ НачалоДуги, КонецДуги ПОМЕСТИТЬ ЗамыканияДлины1 ИЗ ИсходноеОтношение
	            | ОБЪЕДИНИТЬ ВЫБРАТЬ НачалоДуги, НачалоДуги ИЗ ИсходноеОтношение
	            | ОБЪЕДИНИТЬ ВЫБРАТЬ КонецДуги, КонецДуги ИЗ ИсходноеОтношение;";
	Иначе 
		// Проверка конкретной спецификации.
		Пролог = "ВЫБРАТЬ * ПОМЕСТИТЬ ИсходныеКомплектующие
				| ИЗ &ИсходныеКомплектующие КАК ИсходныеКомплектующие;		
				| //////////////////////////////////////////////////
				| ВЫБРАТЬ Выход.Владелец НачалоДуги, Вход.Номенклатура КонецДуги, Выход.Ссылка ПОМЕСТИТЬ ИсходноеОтношение
	            | ИЗ Справочник.СпецификацииНоменклатуры КАК Выход
	            | СОЕДИНЕНИЕ Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК Вход ПО Выход.Ссылка = Вход.Ссылка
				| ГДЕ НЕ Выход.Владелец = &Владелец
				| ОБЪЕДИНИТЬ ВСЕ
				| ВЫБРАТЬ &Владелец НачалоДуги, Вход.Номенклатура КонецДуги, &Ссылка
	            | ИЗ ИсходныеКомплектующие КАК Вход;
	            | ВЫБРАТЬ РАЗЛИЧНЫЕ НачалоДуги, КонецДуги ПОМЕСТИТЬ ЗамыканияДлины1 ИЗ ИсходноеОтношение
	            | ОБЪЕДИНИТЬ ВЫБРАТЬ НачалоДуги, НачалоДуги ИЗ ИсходноеОтношение
	            | ОБЪЕДИНИТЬ ВЫБРАТЬ КонецДуги, КонецДуги ИЗ ИсходноеОтношение;";
		Запрос.УстановитьПараметр("Ссылка", СтрутураОтбора.Ссылка);
		Запрос.УстановитьПараметр("Владелец", СтрутураОтбора.Владелец);
		Запрос.УстановитьПараметр("ИсходныеКомплектующие", СтрутураОтбора.ИсходныеКомплектующие);
	КонецЕсли;	

    Рефрен = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПерваяДуга.НачалоДуги, ВтораяДуга.КонецДуги ПОМЕСТИТЬ ЗамыканияДлины#2 ИЗ ЗамыканияДлины#1 КАК ПерваяДуга
            | СОЕДИНЕНИЕ ЗамыканияДлины#1 КАК ВтораяДуга ПО ПерваяДуга.КонецДуги = ВтораяДуга.НачалоДуги;
            | УНИЧТОЖИТЬ ЗамыканияДлины#1;";

    Эпилог = "ВЫБРАТЬ КОЛИЧЕСТВО(НачалоДуги) Уровень, КонецДуги Элемент ПОМЕСТИТЬ ТаблицаУровней ИЗ ЗамыканияДлины#2 СГРУППИРОВАТЬ ПО КонецДуги;
            | ВЫБРАТЬ ИсходноеОтношение.НачалоДуги Предок, ИсходноеОтношение.КонецДуги Потомок, ИсходноеОтношение.Ссылка Спецификация ИЗ ИсходноеОтношение
            | СОЕДИНЕНИЕ ТаблицаУровней КАК Начало ПО ИсходноеОтношение.НачалоДуги = Начало.Элемент
            | СОЕДИНЕНИЕ ТаблицаУровней КАК КОНЕЦ ПО ИсходноеОтношение.КонецДуги = Конец.Элемент
            | ГДЕ Начало.Уровень = Конец.Уровень";
	
	Запрос.Текст = Пролог;

    МаксимальнаяДлинаЗамыканий = 1;

    Пока МаксимальнаяДлинаЗамыканий < МаксимальнаяДлинаПути Цикл

        Запрос.Текст = Запрос.Текст + СтрЗаменить(СтрЗаменить(Рефрен, "#1", Формат(МаксимальнаяДлинаЗамыканий, "ЧГ=0")), "#2", Формат(2 * МаксимальнаяДлинаЗамыканий, "ЧГ=0"));

        МаксимальнаяДлинаЗамыканий = 2 * МаксимальнаяДлинаЗамыканий

    КонецЦикла;

    Запрос.Текст = Запрос.Текст + СтрЗаменить(Эпилог, "#2", Формат(МаксимальнаяДлинаЗамыканий, "ЧГ=0"));

	Возврат Запрос.Выполнить().Выгрузить()

КонецФункции

// Функция - Определение уровня
//
// Параметры:
//  МаксимальнаяДлинаПути	 - Число	 - Максимальная длина пути, который будем контролировать
// 
// Возвращаемое значение:
//  Таблица - Уровени глубины вхождения
//
Функция ОпределениеУровня(СписокНоменклатуры = Неопределено, МаксимальнаяДлинаПути = 10) Экспорт

	// Определение циклов основано на следующей идее:
	// Будем считать уровнем элемента количество прямо или косвенно «предшествующих» ему других элементов (в смысле
	// конкретного отношения). Такой уровень на основе таблицы транзитивного замыкания легко посчитать для ориентированного
	// графа любого вида. Нетрудно догадаться, что уровень всех элементов, находящихся в цикле, будет одинаков.
	// Тогда признаком того, что дуга принадлежит циклу, будет одинаковый уровень ее концов.

	// В результате получаем следующий запрос, находящий дуги, принадлежащие циклу.
    Запрос = Новый Запрос;

	Если СписокНоменклатуры = Неопределено Тогда 
		// Проверка всех спецификаций.
		Пролог = "ВЫБРАТЬ Выход.Владелец НачалоДуги, Вход.Номенклатура КонецДуги, Выход.Ссылка ПОМЕСТИТЬ ИсходноеОтношение
	            | ИЗ Справочник.СпецификацииНоменклатуры КАК Выход
	            | СОЕДИНЕНИЕ Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК Вход ПО Выход.Ссылка = Вход.Ссылка;
	            | ВЫБРАТЬ РАЗЛИЧНЫЕ НачалоДуги, КонецДуги ПОМЕСТИТЬ ЗамыканияДлины1 ИЗ ИсходноеОтношение
	            | ОБЪЕДИНИТЬ ВЫБРАТЬ НачалоДуги, НачалоДуги ИЗ ИсходноеОтношение
	            | ОБЪЕДИНИТЬ ВЫБРАТЬ КонецДуги, КонецДуги ИЗ ИсходноеОтношение;";
	Иначе 
		// Проверка спецификаций по вхождению конкретной ноенклатуры.
		Пролог = "ВЫБРАТЬ Выход.Владелец НачалоДуги, Вход.Номенклатура КонецДуги, Выход.Ссылка ПОМЕСТИТЬ ИсходноеОтношение
	            | ИЗ Справочник.СпецификацииНоменклатуры КАК Выход
	            | СОЕДИНЕНИЕ Справочник.СпецификацииНоменклатуры.ИсходныеКомплектующие КАК Вход ПО Выход.Ссылка = Вход.Ссылка
				| ГДЕ Вход.Номенклатура В (&СписокНоменклатуры);
	            | ВЫБРАТЬ РАЗЛИЧНЫЕ НачалоДуги, КонецДуги ПОМЕСТИТЬ ЗамыканияДлины1 ИЗ ИсходноеОтношение
	            | ОБЪЕДИНИТЬ ВЫБРАТЬ НачалоДуги, НачалоДуги ИЗ ИсходноеОтношение
	            | ОБЪЕДИНИТЬ ВЫБРАТЬ КонецДуги, КонецДуги ИЗ ИсходноеОтношение;";
		Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
	КонецЕсли;	

    Рефрен = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПерваяДуга.НачалоДуги, ВтораяДуга.КонецДуги ПОМЕСТИТЬ ЗамыканияДлины#2 ИЗ ЗамыканияДлины#1 КАК ПерваяДуга
            | СОЕДИНЕНИЕ ЗамыканияДлины#1 КАК ВтораяДуга ПО ПерваяДуга.КонецДуги = ВтораяДуга.НачалоДуги;
            | УНИЧТОЖИТЬ ЗамыканияДлины#1;";

	Эпилог = "ВЫБРАТЬ КОЛИЧЕСТВО(НачалоДуги) Уровень, КонецДуги Элемент ИЗ ЗамыканияДлины#2 СГРУППИРОВАТЬ ПО КонецДуги";
	
	Запрос.Текст = Пролог;

    МаксимальнаяДлинаЗамыканий = 1;

    Пока МаксимальнаяДлинаЗамыканий < МаксимальнаяДлинаПути Цикл

        Запрос.Текст = Запрос.Текст + СтрЗаменить(СтрЗаменить(Рефрен, "#1", Формат(МаксимальнаяДлинаЗамыканий, "ЧГ=0")), "#2", Формат(2 * МаксимальнаяДлинаЗамыканий, "ЧГ=0"));

        МаксимальнаяДлинаЗамыканий = 2 * МаксимальнаяДлинаЗамыканий

    КонецЦикла;

    Запрос.Текст = Запрос.Текст + СтрЗаменить(Эпилог, "#2", Формат(МаксимальнаяДлинаЗамыканий, "ЧГ=0"));

	Возврат Запрос.Выполнить().Выгрузить()

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НесколькоСпецификацийНоменклатуры(Номенклатура)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(СправочникСпецификаций.Ссылка) КАК КоличествоСпецификаций
		|ИЗ
		|	Справочник.СпецификацииНоменклатуры КАК СправочникСпецификаций
		|ГДЕ
		|	СправочникСпецификаций.Владелец = &Номенклатура
		|	И СправочникСпецификаций.ПометкаУдаления = ЛОЖЬ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.КоличествоСпецификаций > 1;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиОбновленияИнформационнойБазы

#Область ИсправитьРасхожденияВладелецОсновнаяСпецификация

// Исправляет ошибки в данных, которые могли быть допущены в версиях, когда не было УстановитьОсновнойПриСменеВладельца()
//
// Параметры:
//  Параметры – Структура со свойствами, состав которой определяется БСП:
//              * ОбработкаЗавершена (Булево). Для того чтобы обработчик был вызван повторно для обработки следующей
//              порции данных, следует записать в него значение Ложь. * ПрогрессВыполнения (Структура). Данные для
//              отображения прогресса обработки данных: * ВсегоОбъектов (Число). Общее количество объектов, которые
//              необходимо обработать. * ОбработаноОбъектов (Число). Сколько объектов уже обработано.
//
Процедура ИсправитьРасхожденияВладелецОсновнаяСпецификация(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	
	// Выполняем без разбиения на порции исходя из предположения, что количество проблемных объектов небольшое.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Продукция,
	|	СпецификацииНоменклатуры.Ссылка КАК Спецификация,
	|	СпецификацииНоменклатуры.Владелец КАК ВладелецСпецификации
	|ПОМЕСТИТЬ Ошибки
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СпецификацииНоменклатуры КАК СпецификацииНоменклатуры
	|		ПО Номенклатура.ОсновнаяСпецификацияНоменклатуры = СпецификацииНоменклатуры.Ссылка
	|ГДЕ
	|	СпецификацииНоменклатуры.Владелец <> Номенклатура.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВладелецСпецификации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СпецификацииНоменклатуры.Владелец КАК Владелец
	|ПОМЕСТИТЬ НесколькоСпецификаций
	|ИЗ
	|	Ошибки КАК Ошибки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СпецификацииНоменклатуры КАК СпецификацииНоменклатуры
	|		ПО Ошибки.ВладелецСпецификации = СпецификацииНоменклатуры.Владелец
	|			И Ошибки.Спецификация <> СпецификацииНоменклатуры.Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Владелец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Ошибки.Продукция КАК Продукция,
	|	Ошибки.Спецификация КАК Спецификация,
	|	Ошибки.ВладелецСпецификации КАК ВладелецСпецификации,
	|	НесколькоСпецификаций.Владелец ЕСТЬ NULL КАК ЕдинственнаяСпецификацияВладельца
	|ИЗ
	|	Ошибки КАК Ошибки
	|		ЛЕВОЕ СОЕДИНЕНИЕ НесколькоСпецификаций КАК НесколькоСпецификаций
	|		ПО Ошибки.ВладелецСпецификации = НесколькоСпецификаций.Владелец";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
 		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Параметры.ПрогрессВыполнения.ВсегоОбъектов = Параметры.ПрогрессВыполнения.ОбработаноОбъектов + Выборка.Количество();
	
	КоличествоОшибок = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			ИсправитьРасхождениеВладелецОсновнаяСпецификация(
				Выборка.Спецификация,
				Выборка.ВладелецСпецификации,
				Выборка.ЕдинственнаяСпецификацияВладельца,
				Выборка.Продукция);
			
			Параметры.ПрогрессВыполнения.ОбработаноОбъектов = Параметры.ПрогрессВыполнения.ОбработаноОбъектов + 1;
				
		Исключение
			
			// Если не удалось обработать спецификацию, повторим попытку снова (позже).
			
			КоличествоОшибок = КоличествоОшибок + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать спецификацию: %1 по причине:
				|%2'"), 
				Строка(Выборка.Спецификация),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ЗаписьЖурналаРегистрации(
				ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.СпецификацииНоменклатуры,
				Выборка.Спецификация,
				ТекстСообщения);
				
		КонецПопытки;
			
	КонецЦикла;
	
	Если КоличествоОшибок = 0 Тогда
		
		Параметры.ОбработкаЗавершена = Истина;
	
	Иначе
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре ИсправитьРасхожденияВладелецОсновнаяСпецификация не удалось обработать некоторые спецификации. Количество ошибок: %1'"), 
			КоличествоОшибок);
			
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ИсправитьРасхождениеВладелецОсновнаяСпецификация(Спецификация, ВладелецСпецификации, ЕдинственнаяСпецификацияВладельца, Продукция)
	
	НачатьТранзакцию();
	Попытка			
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("Справочник.Номенклатура");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Продукция);
		
		Если ЕдинственнаяСпецификацияВладельца Тогда
			ЭлементБлокировки = Блокировка.Добавить("Справочник.Номенклатура");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВладелецСпецификации);
		КонецЕсли;
		
		Блокировка.Заблокировать();
		
		Объект = Спецификация.ПолучитьОбъект();
		
		Объект.УдалитьУстановкуОсновной(Продукция, Истина);
		
		Если ЕдинственнаяСпецификацияВладельца Тогда
			Объект.УстановитьОсновной(ВладелецСпецификации, Истина);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
