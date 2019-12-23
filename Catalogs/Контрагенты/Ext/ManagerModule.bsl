﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("ИНН");
	Результат.Добавить("КодПоОКПО");
	Результат.Добавить("ОсновнойБанковскийСчет");
	
	Результат.Добавить("КонтактнаяИнформация.*");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
// Функция определяет наличие дублей у контрагента.
// ИНН - ИНН проверяемого контрагента, Тип - Строка(12)
// Ссылка - Сам проверяемый контрагент, Тип - СправочникСсылка.Контрагенты
Функция ПроверитьДублиСправочникаКонтрагентыПоИНН(Знач ИНН, ИсключаяСсылку = Неопределено, ПроверкаПриЗаписи = Ложь) Экспорт
	
	Дубли = Новый Массив;
	
	Запрос = Новый Запрос;
	// Если при записи элемента ничего не нашлось в регистре дублей, 
	// или при интерактивной проверке выполним поиск дублей по справочнику Контрагенты
	Если Дубли.Количество() = 0 Тогда
		
		Запрос.Текст = 	"ВЫБРАТЬ
		               	|	Контрагенты.Ссылка
		               	|ИЗ
		               	|	Справочник.Контрагенты КАК Контрагенты
		               	|ГДЕ
		               	|	НЕ Контрагенты.ЭтоГруппа
		               	|	И НЕ Контрагенты.Ссылка = &Ссылка
		               	|	И Контрагенты.ИНН = &ИНН";
		Запрос.УстановитьПараметр("ИНН", СокрЛП(ИНН));
		Запрос.УстановитьПараметр("Ссылка", ИсключаяСсылку);
		
		ВыборкаДублей = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаДублей.Следующий() Цикл
			Дубли.Добавить(ВыборкаДублей.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
			
	Возврат Дубли;
	
КонецФункции	

#КонецОбласти

#КонецЕсли