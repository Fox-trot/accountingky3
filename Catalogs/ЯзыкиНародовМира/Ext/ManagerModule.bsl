﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
// Используется для сопоставления элементов механизмом «Выгрузка/загрузка областей данных»
//
// Возвращаемое значение: 
//	Массив(Строка) - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
// Процедура выполняет первоначальное заполнение классификатора 
Процедура ВыборочноеНачальноеЗаполнение()
	
	КлассификаторТаблица = Новый ТаблицаЗначений;
	КлассификаторТаблица.Колонки.Добавить("Код");
	КлассификаторТаблица.Колонки.Добавить("Наименование");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "014";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Английский'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "135";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Немецкий'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "213";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Французский'");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЯзыкиНародовМира.Наименование
	               |ИЗ
	               |	Справочник.ЯзыкиНародовМира КАК ЯзыкиНародовМира";
	
	ТаблицаСуществующих = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаКлассификатора ИЗ КлассификаторТаблица Цикл
		Если ТаблицаСуществующих.Найти(СтрокаКлассификатора.Наименование,"Наименование")  = Неопределено Тогда
			СправочникОбъект = Справочники.ЯзыкиНародовМира.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(СправочникОбъект, СтрокаКлассификатора);
			СправочникОбъект.ДополнительныеСвойства.Вставить("ПодборИзКлассификатора");
			СправочникОбъект.ОбменДанными.Загрузка = Истина;
			БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// При работе в модели сервиса классификатор изначально должен быть полностью заполнен
//
Процедура ЗаполнитьСправочникПоКлассификатору() Экспорт
	
	// Полная загрузка классификатора нужна только в сервисе
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда   
		ВыборочноеНачальноеЗаполнение();
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(КлассификаторТаблица.Code КАК СТРОКА(3)) КАК Код,
	|	ВЫРАЗИТЬ(КлассификаторТаблица.Name КАК СТРОКА(50)) КАК Наименование
	|ПОМЕСТИТЬ КлассификаторТаблица
	|ИЗ
	|	&КлассификаторТаблица КАК КлассификаторТаблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КлассификаторТаблица.Код,
	|	КлассификаторТаблица.Наименование
	|ИЗ
	|	КлассификаторТаблица КАК КлассификаторТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЯзыкиНародовМира КАК ЯзыкиНародовМира
	|		ПО КлассификаторТаблица.Код = ЯзыкиНародовМира.Код
	|ГДЕ
	|	ЯзыкиНародовМира.Ссылка ЕСТЬ NULL ");
	
	ТекстовыйДокумент = Справочники.ЯзыкиНародовМира.ПолучитьМакет("КлассификаторЯзыковНародовМира");
	ТаблицаЯзыков = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстовыйДокумент.ПолучитьТекст()).Данные;
	
	Запрос.УстановитьПараметр("КлассификаторТаблица", ТаблицаЯзыков);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СправочникОбъект = Справочники.ЯзыкиНародовМира.СоздатьЭлемент();
		СправочникОбъект.Код = СокрЛП(Выборка.Код);
		СправочникОбъект.Наименование = СокрЛП(Выборка.Наименование);
		СправочникОбъект.ДополнительныеСвойства.Вставить("ПодборИзКлассификатора");
		СправочникОбъект.ОбменДанными.Загрузка = Истина;
		БухгалтерскийУчетКлиентСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли