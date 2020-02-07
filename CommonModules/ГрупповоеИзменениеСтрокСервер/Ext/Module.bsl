﻿////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, предназначенные для группового изменения строк в табличной
// части и управления оформлением панели редактирования.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается при создании формы на сервере; заполняет список выбора поля ввода Действие панели редактирования таблицы.
//
// Параметры:
//  НаборЭлементов - Структура - набор необходимых реквизитов и элементов формы, входящих в панель редактирования.
//    * ДокументСсылка  - ДокументСсылка - Ссылка на документ, в котором происходит редактирование ТЧ.
//    * ИмяТЧ  - Строка - Имя ТЧ, которая будет редактироваться.
//    * ДействиеЭлемент - ПолеФормы - Элемент формы, содержащий выбранное действие для группового изменения строк.
//  Действие       - ПеречислениеСсылка - Выбранное действие для группового изменения строк.
//
Процедура ПриСозданииНаСервере(НаборЭлементов, Действие) Экспорт
	
	НаборЭлементов.ПанельРедактирования.Видимость = Ложь;
	НаборЭлементов.КолонкаПометка.Видимость = Ложь;
	НаборЭлементов.КолонкаПометка.ФиксацияВТаблице = ФиксацияВТаблице.Нет;
	НаборЭлементов.КолонкаНомерСтроки.Видимость = Истина;
	
	КлючОбъекта = ТипЗнч(НаборЭлементов.ДокументСсылка);
	КлючНастроек = "ГрупповоеИзменениеСтрок_" + НаборЭлементов.ИмяТЧ;
	Действие = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек);
	
КонецПроцедуры

// Управляет видимостью командной панели
Процедура ПоказатьСкрытьПанельРедактирования(Форма, НаборЭлементов, СостояниеПерехода, ИзменяетДанные = Неопределено) Экспорт
	
	ВидимостьПанели = НЕ НаборЭлементов.ПанельРедактирования.Видимость;
	НаборЭлементов.ПанельРедактирования.Видимость = ВидимостьПанели;
	
	СостояниеПерехода = ?(ВидимостьПанели, 1, 0);
	НастроитьОформлениеПанелиРедактирования(Форма, НаборЭлементов, СостояниеПерехода, Неопределено, ИзменяетДанные);
	
	ГрупповоеИзменениеСтрокКлиентСервер.УстановитьПредставлениеДействия(НаборЭлементов, Ложь);
	
КонецПроцедуры

// Записывает в пользовательские настройки последнее выбранное действие для изменения таблицы.
// Вызывается при закрытии формы.
//
// Параметры:
//  НаборЭлементов - Структура - набор необходимых реквизитов и элементов формы, входящих в панель редактирования.
//    * ДокументСсылка  - ДокументСсылка - Ссылка на документ, в котором происходит редактирование ТЧ.
//    * ИмяТЧ - Строка - Имя ТЧ, которая будет редактироваться.
//    * ДействиеЭлемент - ПолеФормы - Элемент формы, содержащий выбранное действие для группового изменения строк.
//  Действие       - ПеречислениеСсылка - Выбранное действие для группового изменения строк.
//
Процедура СохранитьНастройки(НаборЭлементов) Экспорт
	
	КлючОбъекта = ТипЗнч(НаборЭлементов.ДокументСсылка);
	КлючНастроек = "ГрупповоеИзменениеСтрок_" + НаборЭлементов.ИмяТЧ;
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, НаборЭлементов.Действие);
	
КонецПроцедуры

// Получает строковое представление действия.
//
// Параметры:
//  ДействиеПеречисление - ПеречислениеСсылка.ДействияГрупповогоИзмененияСтрок - Действие, описание которого необходимо получить.
// Возвращаемое значение:
//  Строка - Представление действия.
Функция ПредставлениеДействия(ДействиеПеречисление) Экспорт
	
	ДействиеПредставление = Строка(ДействиеПеречисление);
	Возврат Лев(ДействиеПредставление, СтрНайти(ДействиеПредставление, "@") - 1);
	
КонецФункции

Процедура НастроитьИсходнуюПанельРедактирования(Значение, НаборЭлементов) Экспорт
	
	Значение = "";
	НаборЭлементов.ЗначениеЭлемент.Заголовок = "Значение";
	ТипСтрока = Новый Массив;
	ТипСтрока.Добавить(Тип("Строка"));
	НаборЭлементов.ЗначениеЭлемент.ОграничениеТипа = Новый ОписаниеТипов(ТипСтрока);
	
КонецПроцедуры

// Управляет оформлением панели редактирования таблицы.
//
// Параметры:
//  ЭтаФорма         - УправляемаяФорма - Форма, в которой происходит групповое изменение строк ТЧ.
//  НаборЭлементов   - Структура - набор необходимых реквизитов и элементов формы, входящих в панель редактирования.
//    * ПанельРедактирования - ГруппаФормы - Группа формы, непосредственно являющаяся панелью редактирования ТЧ.
//    * ГруппаДействие - ГруппаФормы - Группа формы, содержащая поле выбора действия для группового изменения строк.
//    * ГруппаЗначение - ГруппаФормы - Группа формы, содержащая поле ввода значения для группового изменения строк.
//    * ГруппаВыполнить - ГруппаФормы - Группа формы, содержащая кнопку формы, запускающую обработку ТЧ.
//    * КнопкаВыполнитьДействие - КнопкаФормы - Кнопка формы, запускающая обработку ТЧ.
//    * КолонкаПометка - ПолеФормы - Пометка строки.
//    * КолонкаНомерСтроки - ПолеФормы - Номер строки.
//    * Действие - ПеречислениеСсылка.ДействияГрупповогоИзмененияСтрок - Выбранное действие для группового изменения строк.
//    * ЗначениеЭлемент - ПолеФормы - Поле ввода значения для группового изменения строк.
//    * ОбъектИзменений - Строка - Название элемента формы, входящего в состав ТЧ, над которым будут производиться изменения.
//    * КолонкаОбъектИзменений - ПолеФормы - Элемент формы, входящего в состав ТЧ, над которым будут производиться изменения.
//  Состояние        - Число - Состояние формы, к которому происходит переход.
//    * 0 - Панель скрыта.
//    * 1 - Выбор действия.
//    * 2 - Выбор значения.
//    * 3 - Применение изменений.
//    * 4 - Представление изменений.
//  Значение         - ПроизвольноеЗначение - Значение, которое используется для изменения значений колонки ТЧ при
//                                            групповом изменении строк.
//  ИзменяетЗначение - Булево - Определяет, нужно ли загрузить исходное состояние редактируемой ТЧ
//                              при скрытии панели редактирования.
//
Процедура НастроитьОформлениеПанелиРедактирования(ЭтаФорма, НаборЭлементов, Состояние, Значение, ИзменяетЗначение = Неопределено) Экспорт
	
	Если Состояние = 2 И НаборЭлементов.Действие = Перечисления.ДействияГрупповогоИзмененияСтрок.УдалитьСтроки Тогда
		Состояние = 3;
	КонецЕсли;
	
	Если Состояние = 0 Тогда
		
		// 0. Панель скрыта
		Если ЗначениеЗаполнено(ИзменяетЗначение) И ИзменяетЗначение Тогда
			ЭтаФорма.Модифицированность = Истина;
		КонецЕсли;
		
		НаборЭлементов.ПанельРедактирования.Видимость = Ложь;
		НаборЭлементов.КолонкаПометка.Видимость = Ложь;
		НаборЭлементов.КолонкаПометка.ФиксацияВТаблице = ФиксацияВТаблице.Нет;
		НаборЭлементов.КолонкаНомерСтроки.Видимость = Истина;
		НаборЭлементов.КолонкаНомерСтроки.ФиксацияВТаблице = ФиксацияВТаблице.Лево;
		
	ИначеЕсли Состояние = 1 Тогда
		// 1. Выбор действия
		
		НаборЭлементов.КолонкаПометка.Видимость = Истина;
		НаборЭлементов.КолонкаПометка.ФиксацияВТаблице = ФиксацияВТаблице.Лево;
		НаборЭлементов.КолонкаНомерСтроки.Видимость = Ложь;
		НаборЭлементов.КолонкаНомерСтроки.ФиксацияВТаблице = ФиксацияВТаблице.Нет;
		НаборЭлементов.ПанельРедактирования.Видимость = Истина;
		
		Значение = НаборЭлементов.ЗначениеЭлемент.ОграничениеТипа.ПривестиЗначение("");
		
	ИначеЕсли Состояние = 2 Тогда
		// 2. Выбор значения
		
		Если НаборЭлементов.Действие <> Перечисления.ДействияГрупповогоИзмененияСтрок.УдалитьСтроки Тогда
			НаборЭлементов.ЗначениеЭлемент.Видимость = Истина;
		КонецЕсли;
		
		Значение = НаборЭлементов.ЗначениеЭлемент.ОграничениеТипа.ПривестиЗначение("");
		
		Если НаборЭлементов.ЗначениеЭлемент.Видимость Тогда
			ЭтаФорма.ТекущийЭлемент = НаборЭлементов.ЗначениеЭлемент;
		Иначе
			ЭтаФорма.ТекущийЭлемент = НаборЭлементов.КнопкаВыполнитьДействие;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УправлениеРезервнымиКопиями(Форма, Таблица, РезервнаяКопияТаблицыАдрес, СостояниеПерехода, ИзменяетДанные) Экспорт
	
	ИзменяетДанные = ?(ИзменяетДанные = Неопределено, Ложь, ИзменяетДанные);
	Если СостояниеПерехода = 1 Тогда
		СделатьРезервнуюКопиюТаблицы(Форма, Таблица, РезервнаяКопияТаблицыАдрес);
	ИначеЕсли СостояниеПерехода = 0 И НЕ ИзменяетДанные Тогда
		ВосстановитьТаблицуИзРезервнойКопии(Таблица, РезервнаяКопияТаблицыАдрес);
	КонецЕсли;
	
	Если СостояниеПерехода = 1 Тогда
		Если Таблица.Количество()>0 И Таблица[0].Свойство("Пометка") Тогда
			// При открытии устанавливаем пометки
			Для каждого стр Из Таблица Цикл
				стр.Пометка = Истина;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

// Помещает таблицу во временное хранилище.
//
// Параметры:
//  ЭтаФорма - УправляемаяФорма - Форма, в которой происходит групповое изменение строк ТЧ.
//  Таблица  - ДанныеФормыКоллекция - ТЧ, которую требуется поместить во временное хранилище.
//  РезервнаяКопияТаблицыАдрес - Строка - Вернет адрес таблицы во временном хранилище.
//
Процедура СделатьРезервнуюКопиюТаблицы(ЭтаФорма, Таблица, РезервнаяКопияТаблицыАдрес) Экспорт
	
	РезервнаяКопияТаблицыАдрес = ПоместитьВоВременноеХранилище(Таблица.Выгрузить(), ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

// Полностью заменяет текущую таблицу таблицей из временного хранилища.
//
// Параметры:
//  Таблица  - ДанныеФормыКоллекция - ТЧ, которую требуется заменить таблицей во временном хранилище.
//  РезервнаяКопияТаблицыАдрес - Строка - Адрес таблицы во временном хранилище.
//
Процедура ВосстановитьТаблицуИзРезервнойКопии(Таблица, РезервнаяКопияТаблицыАдрес) Экспорт
	
	Таблица.Загрузить(ПолучитьИзВременногоХранилища(РезервнаяКопияТаблицыАдрес));
	
КонецПроцедуры

// Производит групповое изменение строк ТЧ.
//
// Параметры:
//  ЭтаФорма				 - УправляемаяФорма						 - Форма, в которой происходит групповое изменение строк ТЧ.
//  Таблица					 - ДанныеФормыКоллекция					 - ТЧ, над которой производится групповое изменение строк.
//  Действие				 - ПеречислениеСсылка.ДействияГрупповогоИзмененияСтрок	 - Выбранное действие для группового изменения строк.
//  ОбъектДействия			 - Строка												 - Имя реквизита ТЧ объекта, над которым производятся изменения.
//  Значение				 - ПроизвольноеЗначение									 - Значение, которое используется для изменения значений колонки ТЧ при
//  									групповом изменении строк.
//  ИмяЭлементаНоменклатура	 - Строка														 - Имя эелемента номенклатуры
//  ПараметрыОтбора			 - Структура														 - Дополнительные параметры
//
Процедура ОбработатьТаблицу(ЭтаФорма, Таблица, Действие, ОбъектДействия, Значение, ИмяЭлементаНоменклатура, ПараметрыОтбора = Неопределено) Экспорт
	
	Если Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УдалитьСтроки") Тогда
		
		ПомеченныеСтроки = Таблица.НайтиСтроки(Новый Структура("Пометка", Истина));
		
		Для Каждого Строка Из ПомеченныеСтроки Цикл
			
			Таблица.Удалить(Строка);
			
		КонецЦикла;
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьМОЛ") Тогда
		
		Для Каждого Строка Из Таблица Цикл
			
			Если НЕ Строка.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			Строка[ОбъектДействия] = Значение;
			
		КонецЦикла;
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.УстановитьСклад") Тогда
		
		Для Каждого Строка Из Таблица Цикл
			
			Если НЕ Строка.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			Строка.Склад = Значение;
			
		КонецЦикла;
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.РаспределитьСуммуПоКоличеству") Тогда
		
		Если Значение <> Неопределено Тогда
			РаспределитьСуммуПоКолонке(Таблица, "Количество", Значение);
		КонецЕсли;
		
	ИначеЕсли Действие = ПредопределенноеЗначение("Перечисление.ДействияГрупповогоИзмененияСтрок.РаспределитьСуммуПоСуммам") Тогда
		
		Если Значение <> Неопределено Тогда
			РаспределитьСуммуПоКолонке(Таблица, "Сумма", Значение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Распределяет сумму по колонке таблицы.
Процедура РаспределитьСуммуПоКолонке(Таблица, ИмяКолонки, СуммаРаспределения)
	
	Если СуммаРаспределения = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Посчитаем общую помеченных позиций
	ОбщаяСумма = 0;
	Для каждого СтрокаТабличнойЧасти Из Таблица Цикл
		Если НЕ СтрокаТабличнойЧасти.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		ОбщаяСумма = ОбщаяСумма + СтрокаТабличнойЧасти[ИмяКолонки];
	КонецЦикла;
	
	Если ОбщаяСумма = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Теперь распределяем
	СтрокаМаксимальнойСуммы = Неопределено; // На эту строку будем относить остаток после распределения (ошибки округления)
	МаксимальнаяСумма       = 0; // Значение максимальной суммы.
	НепогашеннаяСумма       = СуммаРаспределения;
	
	Для каждого СтрокаТабличнойЧасти Из Таблица Цикл
		Если НЕ СтрокаТабличнойЧасти.Пометка Тогда
			Продолжить;
		КонецЕсли;
			
		ТекущаяСумма = СтрокаТабличнойЧасти.Сумма;
		Дельта       = СуммаРаспределения * СтрокаТабличнойЧасти[ИмяКолонки] / ОбщаяСумма;
		
		// Если Дельта по модулю оказалась больше, чем осталось погасить
		Если Дельта < 0 Тогда
			Дельта = Макс(НепогашеннаяСумма, Дельта)
		Иначе
			Дельта = Мин(НепогашеннаяСумма, Дельта)
		КонецЕсли;
		
		// Проверим текущую сумму на максимум.
		Если ТекущаяСумма > МаксимальнаяСумма Тогда
			МаксимальнаяСумма       = ТекущаяСумма;
			СтрокаМаксимальнойСуммы = СтрокаТабличнойЧасти;
		КонецЕсли;
		
		// Учеличиваем значение
		СтрокаТабличнойЧасти.Сумма = ТекущаяСумма + Дельта;
		
		// Остаток нераспределенной суммы надо уменьшать на дельту реального изменения
		НепогашеннаяСумма = НепогашеннаяСумма - (СтрокаТабличнойЧасти.Сумма - ТекущаяСумма);
		
	КонецЦикла;
	
	// Если что-то осталось, кидаем на строку с максимальной суммой.
	Если НепогашеннаяСумма > 0 И СтрокаМаксимальнойСуммы <> Неопределено Тогда
		СтрокаМаксимальнойСуммы.Сумма = СтрокаМаксимальнойСуммы.Сумма + НепогашеннаяСумма;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьСвязиПараметровВыбора(НаборЭлементов) Экспорт
	
	Если НаборЭлементов.КолонкаОбъектИзменений <> Неопределено Тогда
		НаборЭлементов.ЗначениеЭлемент.СвязиПараметровВыбора = НаборЭлементов.КолонкаОбъектИзменений.СвязиПараметровВыбора;
	Иначе
		НаборЭлементов.ЗначениеЭлемент.СвязиПараметровВыбора = Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
